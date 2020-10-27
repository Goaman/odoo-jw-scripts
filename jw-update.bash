#!/bin/bash

folder_jabberwock=$1
folder_odoo=$2

cd $folder_odoo
previous_commit=$(git log --all --grep='\[IMP] web_editor: update Jabberwock library to commit' --pretty=oneline -n 1 | grep -oE '[^ ]+$')

cd $folder_jabberwock
commit_id=$(git rev-parse --short HEAD)
changelog=$(git log --pretty="format:%s" $previous_commit..HEAD)
echo "Last Jabberwock commit in Odoo:" $previous_commit
echo "Last Jabberwock commit:" $commit_id
if [ $previous_commit == $commit_id ]; then
    echo "Aborting the mission."
else
    echo "Building Jabberwock..."
    echo
    npm run build:odoo
    cp $folder_jabberwock/build/odoo/odoo-integration.js $folder_odoo/addons/web_editor/static/lib/jabberwock/jabberwock.js
    cp $folder_jabberwock/build/odoo/odoo-integration.css $folder_odoo/addons/web_editor/static/lib/jabberwock/jabberwock.css

    message="[IMP] web_editor: update Jabberwock library to commit $commit_id\n\nChangelog:\n$changelog"

    cd $folder_odoo
    git add addons/web_editor/static/lib/jabberwock/jabberwock.js
    git add addons/web_editor/static/lib/jabberwock/jabberwock.css
    printf "$message" | git commit -F -
fi


