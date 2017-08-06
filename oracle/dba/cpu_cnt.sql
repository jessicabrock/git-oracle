-- ********************************************************************
-- * Filename     :   cpu_cnt.sql
-- * Author       : Jess Brock
-- * Original	    : 08-Jun-2015
-- * Last Update  : 08-Jun-2015
-- * Description  : CPU working and waiting counts (processes)
-- * Usage        : @cpu_cnt.sql
-- ********************************************************************

def prog    = 'cpu_cnt.sql'
def title   = 'CPU counts - Working and Waiting'
@title

col  state      for  a15   heading "STATE"
col  sw_event   for  a35   heading "SW EVENT"	word wrap
select
       count(*),
       CASE WHEN state != 'WAITING' THEN 'WORKING'
            ELSE 'WAITING'
       END AS state,
       CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
            ELSE event
       END AS sw_event
    FROM
      v$session
   WHERE
       type = 'USER'
   AND status = 'ACTIVE'
   GROUP BY
      CASE WHEN state != 'WAITING' THEN 'WORKING'
           ELSE 'WAITING'
      END,
      CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
           ELSE event
      END
   ORDER BY
      1 DESC, 2 DESC
/

@clear