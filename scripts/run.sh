# Try to fetch if there are differences
git fetch -p
# bool if remote changes
if [ $(git diff --name-only origin/master | wc -l) -eq "0" ]; then
  echo "  🟢 Git repo is clean."
else
  echo "  🔴 Git repo dirty. Quit."
  exit 1
fi

