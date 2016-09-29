#!/usr/bin/env fish

cd /app/comic/
git add --all
git commit --all -m (date '+%Y-%m%d-%T')'->'$argv[1]
git pull --all
git push -u origin master
cd -

