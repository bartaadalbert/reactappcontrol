#!/bin/bash
APP_NAME=$1

if [ -z $1 ] ; then
    printf "$RED APP NAME not given";
    exit 1;
fi

# check if .gitignore file exists
if [ -f "$APP_NAME/.gitignore" ]; then
    # create a temporary file to store new rules
    tmp_file=$(mktemp)

    # read existing file line by line and modify if necessary
    while IFS= read -r line; do
      if [ -z "$line" ]; then
        continue
      elif [[ $line == "#"* ]]; then
        echo "$line" >> $tmp_file
      elif [[ $line == "/"* ]]; then
        echo "$APP_NAME$line" >> "$tmp_file"
      elif [[ $line == "$APP_NAME"* ]]; then
        echo "$line" >> $tmp_file
      else
        echo "$APP_NAME/${line#$APP_NAME/}" >> $tmp_file
      fi
    done < "$APP_NAME/.gitignore"
    
    echo $tmp_file
fi