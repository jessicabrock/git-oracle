-- ********************************************************************
-- * Filename           : ipx.sql
-- * Author             : Jess Brock
-- * Original           : 17-jul-2013
-- * Last Update        : 17-jul-2013
-- * Description        : Instance parameter report with desc and default
-- * Usage              : Must be run as Oracle user "sys".
-- *			                @ipx.sql <parameter name>
-- ********************************************************************

set verify off
def name=&1

def prog    = 'ipx.sql'
def title   = 'Display Instance Parameter: &name'
@title

col parameter 	format a50 heading "Instance Parameter and Value" word_wrapped
col description format a20 heading "Description" word_wrapped
col default 	format a8  heading "Default?" word_wrapped

select  rpad(i.ksppinm, 35) || ' = ' || v.ksppstvl parameter,
        i.ksppdesc description,
        v.ksppstdf "default"
from    x$ksppi         i,
        x$ksppcv        v
where   v.indx = i.indx
and     v.inst_id = i.inst_id
and     i.ksppinm like '&name%'
order by i.ksppinm
/

set verify on
@clear
undef name