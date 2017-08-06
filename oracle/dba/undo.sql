-- ********************************************************************
-- * Filename		  : undo.sql 
-- * Author		    : Jess Brock
-- * Original		  : 01-MAR-2010
-- * Last Update	: 01-mar-2010
-- * Description	: Report transaction rollback/undo details
-- * Usage		    : @undo.sql
-- ********************************************************************

def prog	= 'undo.sql'
def title	= 'Oracle Transaction rollback/undo details'

@title

col sidx	format      9999  justify c heading 'Session|ID'
col usn   	format     999  justify c heading 'RBS|#'    trunc
col namex	format        a8  justify c heading 'RBS|Name' trunc
col statusx	format      a7  justify c heading 'TRX|Status'
col starttime	format    a12 justify c heading 'Start|Time'


select
	sid sidx,
	xidusn usn,
	name namex,
 	space,
	trn.status statusx,
	substr(start_time,10,8) starttime
from
	v$transaction trn,
	v$rollname rn,
	v$session sn
where
	trn.xidusn   = rn.usn
and	trn.ses_addr = sn.saddr
order by
	sid, name
/

@clear
