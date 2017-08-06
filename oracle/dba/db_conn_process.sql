-- ********************************************************************
-- * Filename        : db_conn_process.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Current/Max db connections & processes
-- * Usage           : @db_conn_process.sql
-- ********************************************************************
def prog    = 'db_conn_process.sql'
def title   = 'Current/Max db connections and processes'
@title
col resource_name       for a15 heading "RESOURCE"
col current_utilization for 99999 heading "CURRENT"
col max_utilization     for 99999 heading "MAX ALLOWED"
SELECT 
    resource_name, current_utilization, max_utilization
FROM
    v$resource_limit
WHERE
    resource_name IN ('sessions','processes') ;
@clear