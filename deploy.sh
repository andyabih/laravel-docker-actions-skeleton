#!/bin/sh
set -e

(git push) || true

git checkout production
git merge main

git push origin production

git checkout main