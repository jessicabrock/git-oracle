-- ********************************************************************
-- * Filename		  : indxstat.sql
-- * Author		    : Jess Brock
-- * Original		  : 06-OCT-2010
-- * Last Update	: 06-OCT-2010
-- * Description	: Show Oracle B*-Tree stats for a given index.
-- * Usage		    : @indxstat.sql <schema> <idx name>
-- * WARNING      : analyze index command will do a table lock
-- ********************************************************************

def schema	= &&1
def idxname	= &&2

def prog	= 'indxstat.sql'
def title	= 'Index Statistics Summary (&schema..&idxname)'


col a form a60 fold_after 1

set echo on feedback on heading off
ttitle off
analyze index &schema..&idxname validate structure;

set echo off feedback off heading off
start title
set heading off

select 'Height              :'||height a,
       'Blocks              :'||blocks a,
       'Name                :'||name   a,
       'Leaf rows           :'||lf_rows a,
       'Leaf blocks         :'||lf_blks a,
       'Leaf rows length    :'||lf_rows_len a,
       'Leaf block length   :'||lf_blk_len a,
       'Branch rows         :'||br_rows a,
       'Branch blocks       :'||br_blks a,
       'Branch rows length  :'||br_rows_len a,
       'Branch block length :'||br_blk_len a,
       'del_lf_rows         :'||del_lf_rows a,
       'del_lf_rows_len     :'||del_lf_rows_len a,
       'distinct keys       :'||distinct_keys a,
       'Most repeated key   :'||most_repeated_key a,
       'Btree space         :'||btree_space a,
       'Used space          :'||used_space a,
       'Percent used        :'||pct_used a,
       'Rows per key        :'||to_char(rows_per_key,'99,990') a,
       'Blks_gets_per_access:'||to_char(blks_gets_per_access,'99,990') a
from   index_stats
/  

undef schema
undef colname
@clear
