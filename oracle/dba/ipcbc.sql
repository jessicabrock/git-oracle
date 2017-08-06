-- ********************************************************************
-- * Filename           : ipcbc
-- * Author             : Jess Brock
-- * Original           : 03-mar-2015
-- * Last Update        : 03-mar-2015
-- * Description        : Instance parameter related to the cache
-- *			                buffer chains.
-- * Usage              : Must be run as Oracle user "sys"
-- *			                @ipcbc.sql
-- * Note               : Based upon the ipx.sql report.
-- ********************************************************************
set pages 99

def prog    = 'ipcbc.sql'
def title   = 'Display CBC Related Instance Parameters'
@title

col param 	format a50 heading "Instance Param and Value" word_wrapped
col description format a20 heading "Description" word_wrapped
col default 	format a8  heading "Default?" word_wrapped

select  rpad(i.ksppinm, 35) || ' = ' || v.ksppstvl param,
        i.ksppdesc description,
        v.ksppstdf "default"
from    x$ksppi	     i,
        x$ksppcv	     v
where   v.indx = i.indx
  and     v.inst_id = i.inst_id
  and     i.ksppinm in
             ('db_block_buffers','_db_block_buffers','db_block_size',
              '_db_block_hash_buckets','_db_block_hash_latches'
             )
order by i.ksppinm
/

@clear
