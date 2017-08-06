-- ********************************************************************
-- * Filename		  : datafile_lis.sql
-- * Author		    : Jess Brock
-- * Original		  : 17-AUG-2012
-- * Last Update	: 20-aug-2012
-- * Description	: Database file listing
-- * Usage		    : @datafile_lis.sql
-- ********************************************************************

def prog	= 'datafile_lis.sql'
def title	= 'Database File List'
@title

col file_type_sort  noprint
col file_type       format a7  heading 'Type'       justify c
col file_name       format a48 heading 'File'       justify c trunc
col file_size       format a7  heading 'Size|in Mb' justify c
col tablespace_name format a14 heading 'Tablespace' justify c trunc

break on file_type duplicates skip 1

select
  1           file_type_sort,
  'CONTROL'   file_type,
  name        file_name,
  ''          file_size,
  ''          tablespace_name
from
  v$controlfile
union
select
  2        file_type_sort,
  'REDO'   file_type,
  group#||':'||member file_name,
  ''       file_size,
  ''       tablespace_name
from
  v$logfile
union
select
  3                                          file_type_sort,
  'DATA'                                     file_type,
  file_name                                  file_name,
  rpad(to_char(bytes/1048576,'99,990'),7)    file_size,
  tablespace_name                            tablespace_name
from
  dba_data_files
union
select
  4						file_type_sort,
  'TEMP'					file_type,
  file_name					file_name,
  rpad(to_char(bytes/1048576,'99,990'),7)	file_size,
  tablespace_name				tablespace_name
from
  dba_temp_files
order by 
  1,5,3
/

@clear
