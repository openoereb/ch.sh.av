# Try to fetch if there are differences
git fetch -p
# bool if remote changes
if [ $(git diff --name-only origin/master | wc -l) -eq "0" ]; then
  echo "  🟢 Git repo is clean => nothing to do."
else
  echo "  🔴 Git repo dirty => commiting changes and pushing"
  git commit . -m "update AV on $(date --iso-8601=seconds) from $DOWNLOAD_URL/$FILE_NAME"
  git push
fi

