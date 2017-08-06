-- ********************************************************************
-- * Filename		  : ip.sql
-- * Author		    : Jess Brock
-- * Original		  : 17-AUG-2008
-- * Last Update	: 24-AUG-2008
-- * Description	: Instance parameter report
-- * Usage		    : @ip.sql <parameter name>
-- ********************************************************************

def p_name=&1
set verify off

def prog	= 'ip.sql'
def title	= 'Instance Parameters'
@title

col name  format a40 heading 'Instance Parameter' justify l wrap
col value format a39 heading 'Value'              justify l trunc

select
  name,
  value
from
  v$parameter
where name like '&p_name%'
order by
  name,
  value
/

set verify on
@clear
undef p_name
