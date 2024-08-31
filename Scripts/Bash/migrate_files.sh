#!/bin/bash

# Source folder containing CSV and JSON files
SOURCE_FOLDER="/home/zizi/posey"

# Destination folder where CSV and JSON files will be moved
DESTINATION_FOLDER="/home/zizi/posey/json_and_CSV"

# Creating destination directory 
mkdir -p $DESTINATION_FOLDER

# Finding CSV and Json files
csv_files=$(find $SOURCE_FOLDER -type f -name "*.csv")
json_files=$(find $SOURCE_FOLDER -type f -name "*.json")

# Check if any CSV or JSON files were found
if [ -z "$csv_files" ] && [ -z "$json_files" ]; then
    echo "No CSV or JSON files found in $SOURCE_FOLDER. Please check your folder."
    exit 1
else
    echo "Moving CSV and JSON files from $SOURCE_FOLDER to $DESTINATION_FOLDER..."

    # Move CSV files
    if [ -n "$csv_files" ]; then
        find $SOURCE_FOLDER -type f -name "*.csv" -exec mv {} $DESTINATION_FOLDER \;
    fi

    # Move JSON files
    if [ -n "$json_files" ]; then
        find $SOURCE_FOLDER -type f -name "*.json" -exec mv {} $DESTINATION_FOLDER \;
    fi

    echo "Files moved successfully."
fi
