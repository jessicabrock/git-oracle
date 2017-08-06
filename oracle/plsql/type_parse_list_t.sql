CREATE OR REPLACE TYPE parse_list_t
AS
-- ---------------------------------------------------------------------------------------
-- Schema-level nested table type to support {%link pkg_utility} parse_list function
-- ---------------------------------------------------------------------------------------
-- %author  Jess Brock
-- %version 1.0
--
-- Date: 04-apr-12
-- ---------------------------------------------------------------------------------------
    TABLE OF varchar2 (2000)
/
show errors type parse_list_t
