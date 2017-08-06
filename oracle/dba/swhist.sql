------------------------------------------------------------
-- * file		  : swhist.sql
-- * desc		  : Session wait statitics histogram
-- * author	  : Jess Brock
-- * orig		  : 03-April-07
-- * lst upt	: 03-April-07 
-- * usage    : swhist.sql <event name>
------------------------------------------------------------

def ev_name=&1

set echo off
set feedback off
set heading off
set verify off

col val2 new_val total_waits noprint

select	sum(wait_count) val2
from	v$event_histogram
where	event like '%&ev_name%'
/
		      
set echo off
set feedback off
set heading on
set verify off

def prog	= 'swhist.sql'
def title	= 'Wait Event Activity Histogram (event:&ev_name)'

@title

col event		format a35		heading "Wait Event" trunc
col wtm			format 99999		heading "ms Wait <="
col wait_count	        format 9999999990	heading "Occurs"
col pct_rt		format 990.00		heading "Running|Occurs %"

select	event,
		wait_time_milli wtm,
		wait_count,
		100*(sum(wait_count) over (order by event,wait_time_milli))/&total_waits pct_rt
from	v$event_histogram
where	event like '%&ev_name%'
order by 1,2
/

undef ev_name
@clear
set echo on
set feedback on
set heading on
set verify on