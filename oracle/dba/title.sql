-- ********************************************************************
-- * Filename		  : title.sql 
-- * Author		    : Jess Brock
-- * Description	: report title header
-- * Usage		    : @title.sql
-- ********************************************************************

set termout off
set tab off

break on today
col today new_value now
select to_char(sysdate, 'DD-MON-YY HH:MIam') today 
from   dual;

col valZ new_value db noprint
select value valZ 
from   v$parameter 
where  name = 'db_name';

col valU new_value osuser
select s.osuser valU
from v$session s, v$process p
where s.paddr = p.addr
and s.sid = (select distinct sid from v$mystat);

clear breaks
set termout on
set heading on
set linesize 120

ttitle -
    left 'Database: &db'        right now              skip 0 -
    left 'Report:   &prog'      center osuser - 
    right 'Page' sql.pno                               skip 1 -
    center '&title'                                    skip 2
