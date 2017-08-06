-- ********************************************************************
-- * Filename		  : sga.sql
-- * Author		    : Jimmy Brock
-- * Original		  : 17-AUG-2009
-- * Last Update	: 20-AUG-2012
-- * Description	: Show basic SGA information
-- * Usage		    : @sga.sql
-- ********************************************************************

set pages 999
def prog	= 'sga.sql'
def title	= 'System Global Area Summary'
@title

comp sum of value on report 
break on report 

col comp  format            a20 heading 'Component'      justify c trunc
col value format 99,999,999,990 heading 'Size (KB)'      justify c trunc

select
  pool comp,
  sum(bytes) value
from
  v$sgastat
where pool != ' '
group by pool
union
select name comp, sum(bytes) value
from   v$sgastat
where name in ('fixed_sga','buffer_cache','log_buffer')
group by name
/

@clear
