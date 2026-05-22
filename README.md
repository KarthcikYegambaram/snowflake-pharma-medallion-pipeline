# Snowflake Enterprise Medallion Architecture Pipeline

![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-blue)
![SQL](https://img.shields.io/badge/SQL-Advanced-green)
![CDC](https://img.shields.io/badge/CDC-Streams%20%26%20Tasks-orange)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-purple)
![SCD2](https://img.shields.io/badge/SCD-Type%202-red)

---

# Project Overview

This project demonstrates a complete enterprise-grade Medallion Architecture implementation in Snowflake using real-world data engineering concepts and production-style ELT processing.

The pipeline processes pharmaceutical sales transactional data through Bronze, Silver, and Gold layers while supporting:

- Incremental data loading
- CDC (Change Data Capture)
- Insert / Update / Delete handling
- Soft Deletes
- SCD Type 2 Dimensions
- Streams & Tasks orchestration
- Data validation rules
- Rejected record handling
- Audit logging
- Fact & Dimension modeling

The solution is fully built using Snowflake SQL and Snowflake-native features.

---

# Architecture Overview

## Medallion Architecture

```text
SOURCE TABLE
     │
     ▼
STREAM (CDC)
     │
     ▼
BRONZE LAYER
(Raw ingestion)
     │
     ▼
STREAM
     │
     ▼
SILVER LAYER
(Cleansed & validated)
     │
     ├──────────────► REJECTED RECORDS
     │
     ▼
STREAMS
     │
     ▼
GOLD LAYER
(Dimensions + Fact Tables)
```

---

# Project Features

## Bronze Layer

The Bronze layer stores raw CDC data from the source system.

### Features

- Raw historical ingestion
- CDC capture using Streams
- Insert / Update / Delete handling
- Metadata tracking
- Batch tracking
- Hash diff generation
- Soft delete identification

### Key Components

- Source Stream
- Bronze Stream
- Bronze Task
- Raw ingestion table

---

## Silver Layer

The Silver layer performs data cleansing, validation, and transformation.

### Features

- Data quality validation
- Standardization
- Type casting
- Business rule enforcement
- Incremental MERGE processing
- Soft delete propagation
- Rejected records tracking

### Validation Examples

- Invalid dates
- Invalid payment methods
- Null branch IDs
- Invalid quantities
- Invalid discount rates
- Expired medicine validation

### Additional Components

- Rejected records table
- Audit log table
- Temporary staging tables

---

## Gold Layer

The Gold layer provides analytics-ready dimensional models.

### Features

- Star schema implementation
- SCD Type 2 dimensions
- Historical tracking
- Fact table loading
- Surrogate key generation
- Business-ready reporting layer

### Dimension Tables

- DIM_DATE
- DIM_BRANCH
- DIM_CUSTOMER
- DIM_MEDICINE
- DIM_SUPPLIER

### Fact Table

- FACT_SALES

---

# CDC (Change Data Capture)

This project supports complete CDC processing using Snowflake Streams.

## Supported Operations

| Operation | Supported |
|---|---|
| INSERT | Yes |
| UPDATE | Yes |
| DELETE | Yes |
| SOFT DELETE | Yes |
| INCREMENTAL LOAD | Yes |

---

# SCD Type 2 Implementation

The project implements Slowly Changing Dimension Type 2 logic for historical tracking.

## SCD2 Columns

| Column | Purpose |
|---|---|
| _IS_CURRENT | Current active record |
| _EFFECTIVE_FROM | Record start timestamp |
| _EFFECTIVE_TO | Record expiry timestamp |

## SCD2 Flow

1. Existing record expires
2. Old row marked inactive
3. New version inserted
4. Full history preserved

---

# Snowflake Features Used

## Core Snowflake Features

- Streams
- Tasks
- MERGE
- HASH DIFF
- AUTOINCREMENT
- UUID_STRING()
- CHANGE_TRACKING
- INFORMATION_SCHEMA
- TEMP TABLES

---

# Data Quality Rules

The Silver layer validates multiple business rules.

## Validation Categories

### Transaction Validation

- Transaction ID cannot be NULL
- Valid transaction date required

### Customer Validation

- Age between 0 and 120
- Gender validation
- Customer city required

### Medicine Validation

- Medicine ID required
- Dosage form validation
- Expiry date validation

### Financial Validation

- Quantity > 0
- Price > 0
- Discount between 0 and 1

---

# Soft Delete Logic

Deletes from source systems are not physically removed.

Instead:

```sql
_IS_SOFT_DELETED = TRUE
```

This preserves historical auditability and supports enterprise compliance requirements.

---

# Audit Logging

Pipeline execution is fully monitored using audit logging.

## Audit Metrics Captured

- Rows processed
- Rows inserted
- Rows updated
- Rows rejected
- Execution timestamp
- Batch ID
- Task status

---

# Project Folder Structure

```text
snowflake-enterprise-medallion-pipeline/
│
├── README.md
├── LICENSE
│
├── sql/
│   ├── 01_create_schemas.sql
│   ├── 02_bronze_layer.sql
│   ├── 03_silver_layer.sql
│   ├── 04_gold_layer.sql
│   ├── 05_streams_tasks.sql
│   ├── 06_fact_tables.sql
│   ├── 07_monitoring_queries.sql
│   └── full_pipeline.sql
│
├── sample-data/
│   └── pharma_sales_sample.csv
│
└── images/
    ├── medallion-architecture.png
    ├── streams-tasks-flow.png
    ├── scd2-flow.png
    └── star-schema.png
```

---

# Pipeline Flow

## End-to-End Flow

```text
Source Table
    │
    ▼
Source Stream
    │
    ▼
Bronze Task
    │
    ▼
Bronze Table
    │
    ▼
Bronze Stream
    │
    ▼
Silver Task
    │
    ▼
Silver Table
    │
    ├────────► Rejected Records
    │
    ▼
Gold Streams
    │
    ├────────► Dimension Task
    │
    └────────► Fact Task
```

---

# Monitoring Queries

## Task Monitoring

```sql
SHOW TASKS IN DATABASE KARTHICKY_DB;
```

## Stream Monitoring

```sql
SHOW STREAMS IN DATABASE KARTHICKY_DB;
```

## Task History

```sql
SELECT *
FROM TABLE(
KARTHICKY_DB.INFORMATION_SCHEMA.TASK_HISTORY()
)
ORDER BY SCHEDULED_TIME DESC;
```

---

# How to Run the Project

## Step 1

Create database:

```sql
CREATE DATABASE KARTHICKY_DB;
```

## Step 2

Upload source data into:

```text
PUBLIC.PHARMA_SALES
```

## Step 3

Enable change tracking:

```sql
ALTER TABLE KARTHICKY_DB.PUBLIC.PHARMA_SALES
SET CHANGE_TRACKING = TRUE;
```

## Step 4

Run SQL scripts in order.

## Step 5

Resume Snowflake Tasks.

```sql
ALTER TASK TASK_LOAD_BRONZE RESUME;
ALTER TASK TASK_LOAD_SILVER RESUME;
ALTER TASK TASK_LOAD_GOLD_DIMS RESUME;
ALTER TASK TASK_LOAD_FACT_SALES RESUME;
```

---

# Performance Optimizations

The pipeline includes several optimization strategies.

## Optimizations Used

- Incremental processing
- Stream-based CDC
- Hash-based change detection
- MERGE operations
- Task scheduling
- Temporary staging tables
- Minimal data movement

---

# Enterprise Concepts Covered

This project demonstrates practical enterprise data engineering concepts.

## Concepts Implemented

- Medallion Architecture
- CDC Pipelines
- Enterprise ELT
- Incremental Data Loading
- Data Warehousing
- Dimensional Modeling
- SCD Type 2
- Audit Logging
- Data Quality Management
- Soft Deletes
- Star Schema
- Snowflake Streams
- Snowflake Tasks

---

# Technology Stack

| Technology | Usage |
|---|---|
| Snowflake | Cloud Data Warehouse |
| SQL | ELT Development |
| Streams | CDC Processing |
| Tasks | Workflow Orchestration |
| SCD Type 2 | Historical Tracking |
| Medallion Architecture | Data Layering |

---

# Sample Use Cases

This architecture can be adapted for:

- Retail analytics
- Pharmaceutical analytics
- Banking pipelines
- Insurance systems
- Healthcare reporting
- Enterprise data warehouses
- Real-time CDC pipelines

---

# Future Improvements

Potential future enhancements:

- Snowpipe integration
- Dynamic Tables
- Error notifications
- Email alerts
- Row-level security
- Data masking
- dbt integration
- CI/CD deployment
- Terraform automation
- Airflow orchestration

---

# Resume Highlights

This project demonstrates experience with:

- Advanced Snowflake SQL
- Enterprise Data Engineering
- CDC Architecture
- Data Warehouse Design
- SCD Type 2 Modeling
- Production ELT Pipelines
- Incremental Processing
- Audit Frameworks
- Data Validation
- Workflow Automation

---

# Author

## Karthick Yegambaram

Data Engineer | Snowflake | SQL | Medallion Architecture | CDC Pipelines

---

# GitHub Topics

```text
snowflake
data-engineering
cdc
streams
tasks
sql
etl
elt
medallion-architecture
scd-type-2
data-warehouse
analytics-engineering
```

---

# License

This project is licensed under the MIT License.
