
-- ============================================================
-- MONITORING QUERIES
-- ============================================================

SHOW TASKS IN DATABASE KARTHICKY_DB;

SHOW STREAMS IN DATABASE KARTHICKY_DB;

SELECT *
FROM TABLE(
    KARTHICKY_DB.INFORMATION_SCHEMA.TASK_HISTORY()
)
ORDER BY SCHEDULED_TIME DESC;
