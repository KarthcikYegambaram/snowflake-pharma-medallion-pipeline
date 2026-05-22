
-- ============================================================
-- CREATE REJECTED RECORDS TABLE
-- ============================================================

CREATE OR REPLACE TABLE KARTHICKY_DB."2_SILVER".REJECTED_RECORDS (

    REJECT_ID NUMBER AUTOINCREMENT,

    TRANSACTION_ID NUMBER,

    REJECT_REASON VARCHAR,

    RAW_DATA VARIANT,

    _REJECTED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()

);
