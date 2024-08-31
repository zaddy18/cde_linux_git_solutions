#!/bin/bash

# Set environment variable for the URL
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Directories
RAW_FOLDER="raw"
TRANSFORMED_FOLDER="Transformed"
GOLD_FOLDER="Gold"

# Create directories if they don't exist
mkdir -p $RAW_FOLDER $TRANSFORMED_FOLDER $GOLD_FOLDER

# Extract: Download the CSV file
echo "Downloading CSV file..."
curl -o $RAW_FOLDER/raw_data.csv $CSV_URL

# Check if the file was downloaded successfully
if [ $? -eq 0 ]; then
    echo "File downloaded successfully and saved to $RAW_FOLDER/raw_data.csv"
else
    echo "Failed to download the file"
    exit 1
fi



# Ensure the downloaded CSV file has read and execute permissions
echo "Ensuring the CSV file has read permissions..."
chmod +rx $RAW_FOLDER/raw_data.csv

# Transform: Rename column and select specific columns
echo "Transforming data..."

# Use awk to rename the column and select specific columns
awk -F, '
BEGIN {OFS=","}
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "Variable_code") {
            $i = "variable_code"
        }
    }
    print "year", "Value", "Units", "variable_code"
}
NR>1 {
    print $1, $5, $6, $9
}
' $RAW_FOLDER/raw_data.csv > $TRANSFORMED_FOLDER/2023_year_finance.csv

# Check if the transformation was successful
if [ $? -eq 0 ]; then
    echo "Data transformed successfully and saved to $TRANSFORMED_FOLDER/2023_year_finance.csv"
else
    echo "Failed to transform the data"
    exit 1
fi

# Load: Move the transformed data to the Gold directory
echo "Loading data into Gold directory..."
cp $TRANSFORMED_FOLDER/2023_year_finance.csv $GOLD_FOLDER/

# Check if the file was copied successfully
if [ $? -eq 0 ]; then
    echo "Data loaded successfully into $GOLD_FOLDER/2023_year_finance.csv"
else
    echo "Failed to load the data"
    exit 1
fi
