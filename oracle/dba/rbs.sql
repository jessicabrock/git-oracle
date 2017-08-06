-- ********************************************************************
-- * Filename		  : rbs
-- * Author		    : Jess Brock
-- * Original		  : 24-SEP-2012
-- * Last Update	: 20-aug-2012
-- * Description	: Rollback segment statistics
-- * Usage		    : @rbs
-- * Note         : The percent extention (% Extn) is the percentage of an 
-- *                additional extent being allocated WHEN A TRX NEEDS TO 
-- *                MOVE INTO THE NEXT rbs extent.
-- *                It is not related to EACH time a transaction writes, 
-- *                only when moving into the next extent.
-- ********************************************************************

def prog	= 'rbs.sql'
def title	= 'Rollback Segment Statistics'
start title

col segment    format           a12 heading 'Segment Name'  justify c trunc
col status     format           a8  heading 'Status'        justify c
col tablespace format           a18 heading 'Tablespace'    justify c trunc
col extents    format           990 heading 'Extents'       justify c
col bytes      format       999,990 heading 'Size|(KB)'     justify c
col extn       format         990.0 heading '% Extn'
col wgratio    format         0.000 heading 'Wait/Get|Ratio'

select
  r.segment_name                   segment,
  r.status                         status,
  r.tablespace_name                tablespace,
  n.extents                        extents,
  n.bytes/1024                     bytes,
  100*(v.shrinks/(v.wraps+0.0001)) extn,
  waits/gets 		           wgratio
from
  dba_rollback_segs  r,
  dba_segments       n,
  v$rollname	     rn,
  v$rollstat         v,
  v$transaction      tr
where
    r.segment_name = n.segment_name
and r.segment_name = rn.name
and rn.usn         = v.usn
order by 2,1,3
/

@clear
