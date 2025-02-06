# Smoked Trout Database - PostgreSQL Implementation

## Overview
This project implements a PostgreSQL database for the "Smoked Trout" trading system. It includes the schema design, data population, and queries to analyze trade routes and financial transactions. The database is designed to model trading routes, planets, space stations, and the various products that are bought and sold within the system.

## Requirements
- PostgreSQL (version 12 or later)
- A PostgreSQL user account `fsad` with database creation permissions
- Data files in CSV format stored in the `data/` folder

## Setup Instructions
### 1. Creating the Database
Run the following command in PostgreSQL to create the required database:
```sql
CREATE DATABASE SmokedTrout WITH OWNER = fsad ENCODING = 'UTF8' CONNECTION LIMIT = -1;
```
Then, connect to the database:
```sql
\c smokedtrout fsad
```

### 2. Creating Tables and Data Types
The schema includes:
- **Custom ENUM types:** `materialState`, `materialComposition`
- **Tables for planets, space stations, products, batches, and trade routes**
- **Foreign key constraints to enforce relationships between entities**

### 3. Populating the Database
To populate the database, the CSV files in the `data/` folder must be loaded. This is done using `COPY` commands. Example:
```sql
\copy Dummy FROM './data/TradeRoutes.csv' WITH (FORMAT CSV, HEADER);
```
After loading data into temporary tables, data is inserted into the main tables, and temporary tables are dropped.

### 4. Querying the Database
#### 4.1 Reporting Taxes Per Company
The `TradingRoute` table includes a derived `Taxes` column, computed as 12% of `lastYearRevenue`:
```sql
ALTER TABLE tradingroute ADD COLUMN taxes decimal;
UPDATE tradingroute SET taxes = lastyearrevenue * 0.12;
SELECT operatingcompany, SUM(taxes) AS "SUM OF TAXES" FROM tradingroute GROUP BY operatingcompany;
```

#### 4.2 Finding the Longest Trading Route
This process:
1. Creates a `RouteLength` table to store trading route lengths.
2. Defines a view `EnrichedCallsAt` that links trading routes to visited space stations.
3. Uses a procedural script to dynamically compute trading route distances.
4. Reports the longest route:
```sql
SELECT monitoringkey FROM routelength WHERE length = (SELECT MAX(length) FROM routelength);
```

## Notes
- Ensure that the CSV files are extracted into the `data/` directory before running the script.
- The script uses dynamic SQL execution within a DO block to compute route distances.
- The `pg_read_server_files` permission is required for the user `fsad` to load data from CSV files.

## Disclaimer
This project is for educational purposes and should not be used for production without further modifications and optimizations.

