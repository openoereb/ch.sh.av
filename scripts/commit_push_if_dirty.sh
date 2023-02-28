# Try to fetch if there are differences
TIMESTAMP=$(date --iso-8601=seconds)
CONTAINERNAME=database
git fetch -p
CHANGES=$(git diff --name-only origin/master | grep ".itf")
if [ $($CHANGES | wc -l) -eq "0" ]; then
  echo "  🟢 Git repo is clean => nothing to do."
else
  echo "  🔴 Git repo dirty => commiting changes and pushing"
  git commit . -m "update AV on $TIMESTAMP from $DOWNLOAD_URL/$FILE_NAME"
  git push
fi
docker run --name $CONTAINERNAME -d -v $(pwd):/data -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -e POSTGRES_DB=$POSTGRES_DB -e POSTGRES_HOST_AUTH_METHOD=md5 -e PG_READ_PWD=$PG_READ_PWD -e PG_WRITE_PWD=$PG_WRITE_PWD -e PG_GRETL_PWD=$PG_GRETL_PWD ghcr.io/openoereb/oereb-db-structure:latest
until docker exec $CONTAINERNAME pg_isready; do
  echo "$CONTAINERNAME was not ready, waiting another cycle"
  sleep 5
done
docker cp ./scripts/insert_data.sh $CONTAINERNAME:/usr/bin
docker exec -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -e POSTGRES_DB=$POSTGRES_DB $CONTAINERNAME ./usr/bin/insert_data.sh
docker commit $CONTAINERNAME ghcr.io/$GITHUB_REPOSITORY:latest
