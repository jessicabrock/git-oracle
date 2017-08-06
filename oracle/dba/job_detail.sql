-- check status of a specific job
-- parameter 1: job_name

-- ********************************************************************
-- * Filename        : job_detail.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Details of a specific scheduler job
-- * Usage           : @job_detail <job name>
-- ********************************************************************
def job=UPPER(&1)
def prog    = 'job_detail.sql'
def title   = 'Details of scheduler job &job'
@title
exec printv('select owner, job_type,job_action,repeat_interval,last_start_date,last_run_duration,next_run_date from dba_scheduler_jobs '|| 
            'where job_name = ''&job_name''')
undef job
@clear
