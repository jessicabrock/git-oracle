-- ********************************************************************
-- * Filename        : longops.sql
-- * author:         : Jess Brock
-- * Original	       : 07-Jul-2013
-- * Last Update     : 07-Jul-2013
-- * Description     : Long running operations
-- * Usage           : @longops.sql
-- ********************************************************************
def prog    = 'longops.sql'
def title   = 'Long running operations'
@title

COLUMN percent FORMAT 999.99         HEADING "PERCENT COMPLETE%"
COLUMN message FORMAT a60 word wrap  HEADING "MESSAGE"
COLUMN sid     FORMAT 999999         HEADING "SID"
COLUMN sql_id  FORMAT a15            HEADING "SQL_ID"
COLUMN stime   FORMAT a25            HEADING "START TIME"
SET FEEDBACK OFF
alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss' ;

SELECT sql_id,sid, to_char(start_time,'dd-mon-yyyy hh24:mi:ss') stime, 
       message,( sofar/totalwork)* 100 percent 
FROM v$session_longops
WHERE sofar/totalwork < 1 ;

alter session set nls_date_format = 'dd-mon-rr' ;
SET FEEDBACK ON
@clear