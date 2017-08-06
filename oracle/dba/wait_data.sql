-- ********************************************************************
-- * Filename        : wait_data.sql
-- * Author          : Jess Brock
-- * Original	       : 05-Jun-2017
-- * Last Update     : 05-Jun-2017
-- * Description     : show session in wait state then show execution plan
-- * Usage           : @wait_data.sql
-- ********************************************************************

col wait_event     for a25
col time_in_second for 99999999
set lines 145
set pages 99
set verify off

def prog    = 'wait_data.sql'
def title   = 'Sessions in Wait state and execution plan'
@title

with wait_data
as
(
	SELECT
	 sid, serial#, username, program, module, action,
	 machine, osuser, sql_id, sql_child_number, blocking_session,
	 decode(state, 'WAITING', event, 'CPU') event,
	 p1, p1text, p2, p2text, p3, p3text,
	 SYSDATE date_time
	 FROM V$SESSION s
	 WHERE s.status = 'ACTIVE'
	 AND wait_class != 'Idle'
         AND username != USER
)
SELECT w.sql_id, w.sql_child_number,w.event wait_event, w.blocking_session,
       COUNT(*) time_in_second, tot_time
 FROM wait_data w, 
   (SELECT sql_id, COUNT(*) tot_time
    FROM  wait_data 
    GROUP BY sql_id
   ) tot
 WHERE w.sql_id = tot.sql_id
 GROUP BY w.sql_id,w.sql_child_number, w.event,w.blocking_session, tot_time
 ORDER BY tot_time, w.sql_id, time_in_second
 /
 prompt   
 prompt Hit ENTER key then enter SQL ID and Child Number to view execution plan
 pause
 
 select *
 from table(dbms_xplan.display_cursor('&sqlid',&child_number))
 /
 set verify on
 @clear