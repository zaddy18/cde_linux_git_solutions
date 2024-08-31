# cde_linux_git_solutions

This repository contains solutions to various tasks using Bash and SQL scripts.

## Table of Contents

- [Bash Scripts](#bash-scripts)
- [SQL Scripts](#sql-scripts)

## Bash Scripts

### ETL Task

This script downloads the CSV file from the specified URL and saves it in the raw directory, Renames a specific column and selects specific columns from the CSV file, then saves the transformed data in the transformed directory.

- **Script**: [CDE_Task1.sh](/home/zizi/posey/cde_linux_git_solutions/Scripts/Bash/CDE_Task1.sh)

### Import CSV to PostgreSQL

This script iterates over CSV files in a specified directory, ensures they are readable and executable, infers the schema for each file, creates the corresponding tables in the `posey` PostgreSQL database, and then imports the data into those tables.

- **Script**: [copy_csv_to_posey_db.sh](/home/zizi/posey/cde_linux_git_solutions/Scripts/Bash/copy_csv_to_posey_db.sh)


### Move CSV and JSON files

This script creates a destination folder, checks the source folder for CSV and Json files and moves the files (If available) to the destination folder.

- **Script**: [migrate_files.sh](/home/zizi/posey/cde_linux_git_solutions/Scripts/Bash/migrate_files.sh)

### Dependencies
- `curl`: Used to download the CSV file. Ensure curl is installed on your system.
- `awk`: Used to transform the CSV file. Ensure awk is installed on your system.

### Usage
- Run with bash script.sh or;
- Enable permissions to the script by: chmod +x script.sh before running.

## SQL Script

This script contains queries that interact with the `posey` database on Postgres and generate results:

1. **SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;** . This query retrieves the `id` field from the orders table and filters rows where either the `gloss_qty` or `poster_qty` (or both) is greater than 4000.

1. **SELECT *
FROM orders
WHERE standard_qty = 0
AND (gloss_qty > 1000 OR poster_qty > 1000);** . Selects all columns (*) from the `orders` table and filters rows where the `standard_qty` is zero and either the `gloss_qty` or `poster_qty` (or both) is over 1000.


1. **SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
  AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
  AND primary_poc NOT LIKE '%eana%';** . It retrieves the `name` column from the accounts table and filters where `name` starts with ‘C’ or ‘W’,`primary_poc` contains ‘ana’ or ‘Ana’ and p`primary_poc` does not contain ‘eana’.

1. **SELECT
    r.name as region,
    s.name as sales_rep,
    a.name as account_name
FROM
    region r
JOIN
    sales_reps s ON r.id = s.region_id
JOIN
    accounts a ON s.id = a.sales_rep_id
ORDER BY
    a.name ASC;** . This query joins three tables: region, sales_reps, and accounts. Selects three columns: `region.name`, `sales_reps.name`, and `accounts.name`. The accounts are sorted alphabetically by `account name`.
