if git diff-index --quiet HEAD --; then
  echo "  🟢 Git repo is clean."
else
  echo "  🔴 Git repo dirty. Quit."
  exit 1
fi

