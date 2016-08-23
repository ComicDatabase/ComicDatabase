#!/usr/bin/env fish

cd /app/comic/
git add --all
git commit --all -m (date '+%Y%m%d-%T')
git push -u origin master

