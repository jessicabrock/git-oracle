-- ********************************************************************
-- * Filename        : fts.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : check library cache for queries that use a
-- *                   full table or full index scan
-- * Usage           : @fts
-- * Note            : CAUTION on a large system may take a while
-- ********************************************************************
def prog    = 'fts.sql'
def title   = 'Queries that use full table or full index scan'
@title
set feedback off
alter session set statistics_level=all;

select
        plan_table_output  -- (the column of the pipelined function)
from    (
                select
                        distinct sql_id, child_number
                from
                        v$sql_plan
                where
                      object_owner = UPPER('&OWNER')
                and   (operation = 'TABLE ACCESS' and options = 'FULL')
                or      (operation = 'INDEX' and options = 'FAST FULL SCAN')
        ) v,
        table(dbms_xplan.display_cursor(v.sql_id, v.child_number))
/

alter session set statistics_level = typical;
set feedback on
@clear
