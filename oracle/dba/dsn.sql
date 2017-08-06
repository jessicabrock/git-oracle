-- ********************************************************************
-- * Filename		  : dsn.sql
-- * Author		    : Jess Brock
-- * Original		  : 08-Jun-2014
-- * Last Update	: 08-Jun-2014
-- * Description	: Data row and data block selectivity for NUMBER COLUMNS (orcl 8+)
-- * Usage		    : @ds.sql <tbl owner> <tbl name> <col nm>
-- ********************************************************************

def ownr        = &&1
def tnam        = &&2
def cnam        = &&3

def prog    = 'dsn.sql'
def title   = 'Row and Data Block Selectivity (&ownr..&tnam..&cnam)'

col colname justify c format 999,999,999,990.000 heading '&cnam|Column|Value'
col da_blks justify c format 0.999               heading 'Data Block|Selectivity'
col da_rows justify c format 0.999               heading 'Row|Selectivity'

set termout off echo off feedback off

col val1 new_val nrows noprint
select count(*) val1 from &ownr..&tnam
/
col val2 new_val nblks noprint
select count(distinct(
	  dbms_rowid.rowid_relative_fno(rowid)||'.'||
	  dbms_rowid.rowid_block_number(rowid))) val2
from &ownr..&tnam
/

start title

select
  &cnam                                                  colname,
  count(distinct(
	  dbms_rowid.rowid_relative_fno(rowid)||'.'||
	  dbms_rowid.rowid_block_number(rowid)))/&nblks  da_blks,
  count(*)/&nrows                                        da_rows
from
  &ownr..&tnam
group by
  &cnam
order by
  2 desc,
  1 asc
/

undef ownr
undef tnam
undef cnam
@clear
