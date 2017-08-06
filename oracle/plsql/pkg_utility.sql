CREATE OR REPLACE PACKAGE  pkg_utility
     AUTHID CURRENT_USER
AS
--  Package for general helper subprograms
--
-- -------------------------------------------------------------------------------------
--  Naming Standards
--    l_<>    Local Variables
--    c_<>    Constants
--    g_<>    Package Globals
--    ex_     User defined Exceptions
--    r_<>    Records
--    cs_<>   Cursors
--    csp_<>  Cursor Parameters
--    <>_T    Types
--    <>_O    Object Types
-- --------------------------------------------------------------------------------------
-- %author  Jess Brock
-- %version 1.0
-- Date: 04-APR-2012
--
-- --------------------------------------------------------------------------------------

    FUNCTION strval (i_bool_val IN BOOLEAN)
        RETURN VARCHAR2 ;

    PROCEDURE pl (i_string IN VARCHAR2, i_length IN PLS_INTEGER := 80) ;

    PROCEDURE pl (i_clob IN CLOB, i_length IN PLS_INTEGER := 80) ;

    PROCEDURE pl (i_bool_val IN BOOLEAN) ;

    FUNCTION in_list ( i_string VARCHAR2 )
        RETURN   in_list_t ;

    FUNCTION is_number ( i_number    IN   VARCHAR2 )
       RETURN   BOOLEAN ;

    FUNCTION is_date (   i_date          IN   VARCHAR2
                       , i_date_format   IN   VARCHAR2   DEFAULT 'DD-MON-RR'
                     )
       RETURN BOOLEAN ;

    FUNCTION is_column_list_valid(   i-col_list   IN   VARCHAR2
                                   , i_owner       IN   VARCHAR2
                                   , i_delimiter  IN   VARCHAR2 DEFAULT ','
                                 )
       RETURN BOOLEAN ;

    FUNCTION set_client_identifier
       RETURN varchar2 ;

    FUNCTION convert_raw(   i_rawval   IN   RAW
                          , i_type     IN   VARCHAR2 )
       RETURN varchar2 ;

END pkg_utility ;
/
show errors