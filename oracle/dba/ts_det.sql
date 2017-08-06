-- ********************************************************************.
-- * Filename		  : ts_det.sql 
-- * Author		    : Jimmy Brock
-- * Original		  : 17-AUG-2010
-- * Last Update	: 11-Mar-2010
-- * Description	: Report tablespace details
-- * Usage		    : @ts_det.sql
-- ********************************************************************

def prog	= 'ts_det.sql'
def title	= 'Oracle Database Tablespace Space Summary'

start title

break on report
compute sum of totspace fspace uspace uextents ffrags on report

col tsname   format         a25 justify c heading 'Tablespace|Name' trunc
col totspace format      999990 justify c heading 'Total|Space|(MB)'
col fspace   format      999990 justify c heading 'Free|Space|(MB)'
col uspace   format      999990 justify c heading 'Used|Space|(MB)'
col pctusd   format         990 justify c heading 'Pct|Used'
col umaxext  format       99990 justify c heading 'Biggest|Data|Ext|(MB)'
col uextents format      999990 justify c heading 'Num of|Data|Exts'
col fmaxfrag format       99990 justify c heading 'Biggest|Free|Ext|(MB)'
col ffrags   format       99990 justify c heading 'Num Free|Exts'
col em       format         a5  trunc heading 'Ext|Mgt' trunc
col at       format         a5  trunc heading 'Alloc|Type' trunc

set termout off feedback off verify off
col val1 new_val db_block_size noprint
select value val1
from   v$parameter
where  name = 'db_block_size'
/
set termout on

select
  fx.ts_name		tsname,
  (fx.free_space+nvl(u.used_space,0))/1048576 totspace,
  nvl(fx.free_space/1048576,0)	fspace,
  nvl(u.used_space/1048576,0)	uspace,
  nvl(100*nvl(u.used_space,0)/(fx.free_space+u.used_space),0) pctusd,
  nvl(u.max_ext_size/1048576,0)	umaxext,
  nvl(u.num_exts,0)		uextents,
  fx.max_frag_size/1048576	fmaxfrag,
  fx.num_frags		        ffrags,
  t.extent_management           em, 
  t.allocation_type             at
from
(
  select
    tablespace_name                     ts_name,
    sum(bytes)                          free_space,
    max(bytes)                          max_frag_size,
    count(bytes)                        num_frags
  from
    dba_free_space
  group by
    tablespace_name
  union
  select
    f.tablespace_name           ts_name,
    sum(f.blocks*&db_block_size)-nvl(sum(u.blocks*&db_block_size),0) free_space,
    -1                          max_frag_size,
    -1                          max_frags
  from
    dba_temp_files f,
    v$sort_usage   u
  where
    f.tablespace_name = u.tablespace (+)
  group by
    f.tablespace_name
) fx,
(
  select
    tablespace_name                     ts_name,
    sum(bytes)                          used_space,
    max(bytes)                          max_ext_size,
    count(bytes)                        num_exts
  from
    dba_extents
  group by 
    tablespace_name
union
  select
    tablespace                          ts_name,
    sum(blocks*&db_block_size)          used_space,
    max(extents)                        max_ext_size,
    count(extents)                      num_exts
  from
    v$sort_usage
  group by
  tablespace
) u,
  dba_tablespaces t
where
  fx.ts_name = u.ts_name(+) and
  t.tablespace_name = fx.ts_name
order by
  fx.ts_name
/

@clear
