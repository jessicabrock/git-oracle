-- ********************************************************************
-- * Filename        : sess_act.sql
-- * Author          : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : list active users
-- * Usage           : @sess_act.sql
-- ********************************************************************

set pages 99
set lines 145
def prog    = 'sess_act.sql'
def title   = 'Active Sessions'
@title

col sid       for 9999999
col serial#   for 9999999
col sql_id    for a20
col spid      for a7
col username  for a15 word wrap
col osuser    for a15
col program   for a35 word wrap
SELECT     s.sid      , 
           s.serial#  ,
           s.sql_id   ,
           p.spid     ,
           s.username ,
           s.osuser   ,
           s.program
FROM       v$session s, v$process p
WHERE      s.paddr = p.addr
AND        s.type = 'USER'
AND        s.status = 'ACTIVE'
/

@clear
