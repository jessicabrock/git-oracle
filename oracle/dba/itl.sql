-- ********************************************************************
-- * Filename		  : itl.sql 
-- * Author		    : Jess Brock
-- * Original		  : 15-nov-2011
-- * Last Update	: 15-nov-2011
-- * Description	: Detect ITL (interested transaction list)
-- * Usage		    : 
-- ********************************************************************
col object_name for a35
col type for a5
def prog    = 'itl.sql'
def title   = 'Interested Transaction List (ITL)'
@title
select 
   s.sid SID,
   s.serial# Serial#,
   l.type type,
   ' ' object_name,
   lmode held,
   request request
from 
   v$lock l, 
   v$session s, 
   v$process p
where 
   s.sid = l.sid and
   s.username <> ' ' and
   s.paddr = p.addr and
   l.type <> 'TM' and
   (l.type <> 'TX' or l.type = 'TX' and l.lmode <> 6)
union
select 
   s.sid SID,
   s.serial# Serial#,
   l.type type,
   object_name object_name,
   lmode held,
   request request
from 
   v$lock l,
   v$session s,
   v$process p, 
   sys.dba_objects o
where 
   s.sid = l.sid and
   o.object_id = l.id1 and
   l.type = 'TM' and
   s.username <> ' ' and
   s.paddr = p.addr
union
select 
   s.sid SID,
   s.serial# Serial#,
   l.type type,
   '(Rollback='||rtrim(r.name)||')' object_name,
   lmode held,
   request request
from 
   v$lock l, 
   v$session s, 
   v$process p, 
   v$rollname r
where 
   s.sid = l.sid and
   l.type = 'TX' and
   l.lmode = 6 and
   trunc(l.id1/65536) = r.usn and
   s.username <> ' ' and
   s.paddr = p.addr
order by 5, 6;
@clear