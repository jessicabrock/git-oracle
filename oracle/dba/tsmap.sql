-- ********************************************************************
-- * Filename		  : tsmap.sql - Version 1.0
-- * Author		    : Jess Brock
-- * Original		  : 17-AUG-98
-- * Last Update	: 20-AUG-02
-- * Description	: Tablespace block mapping summary
-- * Usage		    : start tsmap.sql <tablespace name>
-- ********************************************************************

def ts		= &&1

prompt Objects of type TEMPORARY will not be displayed
prompt

def prog	= 'tsmap.sql &ts'
def title	= 'Tablespace Block Map'

@title

col tablespace format       a15 justify c trunc heading 'Tablespace'
col file_id    format       990 justify c       heading 'File'
col block_id   format 9,999,990 justify c       heading 'Block Id'
col blocks     format   999,990 justify c       heading 'Size'
col segment    format       a38 justify c trunc heading 'Segment'

break on tablespace skip page

select
  tablespace_name	       tablespace,
  file_id,
  block_id,
  blocks,
  owner||'.'||segment_name     segment
from
  dba_extents
where
  tablespace_name = upper('&ts')
union
select
  tablespace_name	       tablespace,
  file_id,
  block_id,
  blocks,
  '<free>'
from
  dba_free_space
where
  tablespace_name = upper('&ts')
order by
  1,2,3
/

undef ts
@clear
