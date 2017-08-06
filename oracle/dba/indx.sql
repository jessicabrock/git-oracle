-- ********************************************************************
-- * Filename		  : indx.sql - Version 1.0
-- * Author		    : Jess Brock
-- * Original		  : 17-AUG-2014
-- * Last Update	: 24-SEP-2014
-- * Description	: table index column info
-- * Usage		    : @indx.sql <schema> <table name>
-- ********************************************************************

set verify off
def schema	= &&1
def tabname	= &&2

def prog	= 'indx.sql'
def title	= 'Index Column Summary (&schema..&tabname)'

@title

col uniq    format a10 heading 'Uniqueness'  justify c trunc
col indname format a40 heading 'Index Name'  justify c trunc
col colname format a25 heading 'Column Name' justify c trunc

break on indname skip 1 on uniq

select
  ind.uniqueness                  uniq,
  ind.owner||'.'||col.index_name  indname,
  col.column_name                 colname
from
  dba_ind_columns  col,
  dba_indexes      ind
where
  ind.owner = upper('&schema')
    and
  ind.table_name = upper('&tabname')
    and
  col.index_owner = ind.owner 
    and
  col.index_name = ind.index_name
order by
  col.index_name,
  col.column_position
/

undef schema
undef tabname
set verify on
@clear
