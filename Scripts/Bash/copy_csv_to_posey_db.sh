#!/bin/bash

# Set environment variables for PostgreSQL connection
export PGHOST="localhost"
export PGPORT="5432"
export PGUSER="your_username"
export PGPASSWORD="your_password"
export PGDATABASE="posey"

# Directory containing CSV files
CSV_DIR="/home/zizi/posey"

# Ensure the script has execute permissions
#chmod +x $0

# Function to infer the schema of a CSV file
infer_schema() {
    local csv_file=$1
    local header=$(head -n 1 $csv_file)
    local sample_data=$(tail -n 1 $csv_file)

    IFS=',' read -r -a columns <<< "$header"
    IFS=',' read -r -a data <<< "$sample_data"

    local schema=""
    for ((i=0; i<${#columns[@]}; i++)); do
        local column=${columns[$i]}
        local value=${data[$i]}

        # Infer data type based on the sample data
        if [[ $value =~ ^[0-9]+$ ]]; then
            schema+="$column INTEGER, "
        elif [[ $value =~ ^[0-9]+\.[0-9]+$ ]]; then
            schema+="$column FLOAT, "
        elif [[ $value =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            schema+="$column DATE, "
        else
            schema+="$column TEXT, "
        fi
    done

    # Remove the trailing comma and space
    schema=${schema%", "}
    echo "$schema"
}

# Function to create a table and import CSV data
import_csv_to_postgres() {
    local csv_file=$1
    local table_name=$(basename $csv_file .csv)

    echo "Processing $csv_file..."

    # Infer the schema of the CSV file
    local schema=$(infer_schema $csv_file)

    # Create a table with the inferred schema
    psql -c "
        CREATE TABLE IF NOT EXISTS $table_name (
            
            $schema
        );
    "

    # Import CSV data into the table
    psql -c "\COPY $table_name FROM '$csv_file' DELIMITER ',' CSV HEADER;"

    if [ $? -eq 0 ]; then
        echo "Data from $csv_file imported successfully into table $table_name"
    else
        echo "Failed to import data from $csv_file"
    fi
}

# List of CSV files to import
csv_files=(
    "accounts.csv"
    "orders.csv"
    "region.csv"
    "sales_reps.csv"
    "web_events.csv"
)

# Iterate over the list of CSV files
for csv_file in "${csv_files[@]}"; do
    import_csv_to_postgres "$CSV_DIR/$csv_file"
done
