-- ********************************************************************
-- * Filename        : fk_depnd.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Find foreign key references to a table
-- * Usage           : @fk_depend.sql <owner> <table>
-- ********************************************************************

def owner=&1
def tab=&2
def prog    = 'fk_depnd.sql'
def title   = 'List all foreign key references to table &table'
@title
set verify off
col owner           for a30 heading "OWNER"
col table_name      for a30 heading "TABLE_NM"
col constraint_name for a30 heading "CONSTRAINT_NM"
col status          for a15 heading "STATUS"

select table_name, constraint_name, status, owner
from dba_constraints
where r_owner = UPPER('&owner')
and constraint_type = 'R'
and r_constraint_name in
 (
   select constraint_name from dba_constraints
   where constraint_type in ('P', 'U')
   and table_name = UPPER('&tab')
   and owner = UPPER('&&owner')
 )
order by table_name, constraint_name   ;

set verify on
undefine tab
undefine owner
@clear
