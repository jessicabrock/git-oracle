-- ********************************************************************
-- * Filename        : mysess.sql
-- * author:         : Jess Brock
-- * Original	       : 27-Sep-2012
-- * Last Update     : 27-Sep-2012
-- * Description     : Session activity for <user>
-- * Usage           : @mysess.sql <user>
-- ********************************************************************
def user=UPPER(&1)
def prog    = 'mysess.sql'
def title   = 'Session activity for &user'
@title

COLUMN sid      FORMAT 999999
COLUMN serial#  FORMAT 999999
COLUMN spid     FORMAT A10
COLUMN username FORMAT A10
COLUMN program  FORMAT A45

SELECT s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program
FROM   v$session s
       JOIN v$process p 
       ON   p.addr = s.paddr 
WHERE  s.type = 'USER'
AND    s.username = '&user' ;

undef user
@clear