#!/bin/bash
git checkout source
git branch -D master
git checkout -b master
git filter-branch --subdirectory-filter _site/ -f
git pull origin master
git push --all
git checkout source