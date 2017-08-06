-- ********************************************************************
-- * Filename        : cpu_sess.sql
-- * Author          : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : find cpu intensive sessions during the last hour
-- * Usage           : @cpu_sess.sql
-- ********************************************************************

set pages 999
set lines 120
PROMPT sessions logged on in the past hour and active in past 30-mins

def prog    = 'cpu_sess.sql'
def title   = 'CPU intensive sessions for the past hour'
@title

col   sql_id for a15     heading "SQL_ID"
col   sid for a10        heading "SID"
col   serial# for a10    heading "SERIAL"
col   "OSPID" for a10    heading "OS PID"
col   osuser for a15     heading "OS USER"
col   module for a15     heading "MODULE"
col   "CPU sec" for a15  heading "CPU/sec"

SELECT s.sql_id,to_char (s.sid, '999999') SID, to_char (s.serial#, '999999') serial#, 
       to_char (p.spid, '99999') as "OSPID",
       s.osuser, s.module, to_char (st.value/100, '999,999.9999') as "CPU sec"
FROM v$sesstat st, v$statname sn, v$session s, v$process p
WHERE sn.name = 'CPU used by this session' -- CPU
AND st.statistic# = sn.statistic#
AND st.sid = s.sid
AND s.paddr = p.addr
AND s.last_call_et < 1800 -- active within last 1/2 hour
AND s.logon_time > (SYSDATE - 60/1440) -- sessions logged on within 1 hours
ORDER BY st.value desc;

@clear
