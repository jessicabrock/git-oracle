-- ********************************************************************
-- * Filename        : db_size.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Report size of the database in GB
-- * Usage           : @db_size.sql <db name>
-- * Note            : Includes temp tablespace, exclude if not needed
-- ********************************************************************
def db=(UPPER&1)
def prog    = 'db_size.sql'
def title   = 'Size of database &1 in GB'
@title
select a.data_size+b.temp_size+c.redo_size+d.controlfile_size "total_size in GB"
from 
( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) a,
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) b,
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_$log ) c,
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v$controlfile) d;
undef db
@clear