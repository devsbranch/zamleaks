#! /usr/bin/env sh
set -e

cd client/
npm install -d
npm install -g grunt
grunt build

grunt copy:sources
grunt build

cd ../backend && python3.9 -m pip install -r requirements.txt 
cd /var/globaleaks

# sudo ./backend/bin/globaleaks -z -n