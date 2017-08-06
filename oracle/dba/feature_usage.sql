-- find Oracle features that the database is using
-- this way Oracle can sue you if you are using an unlicensed feature
-- dependecy function printv


-- ********************************************************************
-- * Filename        : feature_usage.sql
-- * author:         : Jess Brock
-- * Original	       : 08-Jun-2016
-- * Last Update     : 08-Jun-2016
-- * Description     : Displays Oracle features that have been used
-- * Usage           : @feature_usage.sql
-- * Note            : Requires user-defined function PRINTV
-- ********************************************************************
def prog    = 'feature_usage.sql'
def title   = 'Oracle feautures that heve been used - in case we''re audited'
@title
BEGIN
   printv('select dbid, name, version, detected_usages, currently_used, first_usage_date, last_usage_date, description ' ||
          'from dba_feature_usage_statistics');
END ;
/
@clear
