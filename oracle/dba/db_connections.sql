-- ********************************************************************
-- * Filename        : db_conn.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Current db connections and max connections allowed
-- * Usage           : @db_conn.sql
-- ********************************************************************
def prog    = 'db_conn.sql'
def title   = 'Current db connections and max connections allowed'
@title
SELECT
  'Currently, ' 
  || (SELECT COUNT(*) FROM V$SESSION WHERE status ='ACTIVE' and type='USER')
  || ' out of ' 
  || VP.VALUE 
  || ' connections are used.' AS USAGE_MESSAGE
FROM 
  V$PARAMETER VP
WHERE VP.NAME = 'sessions' ;
@clear