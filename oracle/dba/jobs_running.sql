-- ********************************************************************
-- * Filename        : jobs_running.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : What scheduler jobs are currently running
-- * Usage           : @jobs_running.sql
-- ********************************************************************
def prog    = 'jobs_running.sql'
def title   = 'Scheduler jobs currently running'
@title

col job        for a25 word wrap   heading "JOB NM"
col username   for a20             heading "USER"
col sid        for 99999           heading "SID"
col serial#    for a14             heading "SERIAL#"
col spid       for 9999999         heading "SPID"
col lockwait   for a7              heading "LOCKWAIT"
col this_date  for a20             heading "START TIME"    

select
   jr.job,
   s.username,
   s.sid,
   s.serial#,
   p.spid,
   s.lockwait,
   jr.this_date
from 
   dba_jobs_running jr,
   v$session s,
   v$process p
where
   jr.sid = s.sid
and
   s.paddr = p.addr
order by
   jr.job
;
@clear