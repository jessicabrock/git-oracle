-- ********************************************************************
-- * Filename		  : sess_work.sql
-- * Author		    : Jess Brock
-- * Original		  : 17-AUG-2012
-- * Last Update	: 20-aug-2012
-- * Description	: Session and their current work
-- * Usage		    : @sess_work.sql <schema name>
-- ********************************************************************

set pages 999
set lines 125
set verify off

def schema      = UPPER('&1')
def prog	= 'sess_work.sql'
def title	= 'Session Current Work - &1'

col sid            for   9999999
col serial#        for   9999999
col sql_id         for   a15
col hash_value     for   999999999999
col cpu_time       for   9999999999   hea CPU_TIME/SEC
col elapsed_time   for   9999999999   hea ELAPSED/SEC
col sql_text       for   a48
@title

select     s.sid,
           s.serial#,
           s.sql_id,
           sa.hash_value,
           /* microseconds to seconds */
           (1 * POWER(10,-6) * sa.cpu_time)            cpu_time,
           TRUNC((1 * POWER(10,-6) * sa.elapsed_time)) elapsed_time,     
           SUBSTR(sa.sql_text,1,45) || '...'           sql_text
from v$sqlarea sa, v$session s
where s.sql_hash_value = sa.hash_value
and s.sql_address    = sa.address
and s.status = 'ACTIVE'
and s.type   = 'USER'
and s.username = &schema;

set verify on
undef schema
@clear
