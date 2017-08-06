CREATE OR REPLACE PACKAGE BODY pkg_utility
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
-- %author  Jimmy Brock
-- %version 1.0
-- Date: 04-APR-2012
--
-- --------------------------------------------------------------------------------------
--
-- author:  Jess Brcok
-- Date:    09-JUL-2012
-- Task:    
-- Description: 
--
-- --------------------------------------------------------------------------------------

---------------------------------------------------------------------
--  Purpose: convert Boolean value to String
--
--  %param   bool_val_in   The boolean value to be converted
--
---------------------------------------------------------------------
    FUNCTION strval (i_bool_val IN BOOLEAN)
        RETURN VARCHAR2
    IS
    BEGIN
        IF    i_bool_val
        THEN
              RETURN ('TRUE');
        ELSIF NOT
              i_bool_val
        THEN
              RETURN ('FALSE');
        ELSE
              -- this is not a valid boolean value, but some people think it is
              RETURN ('NULL');
        END IF ;
    END strval ;

    --------------------------------------------------------------------
    -- PURPOSE: simple DBMS_OUTPUT handling of 255 char limit
    --          looks for a newline, or chops to fit given length
    --          Overloaded procedure
    --
    -- %param   i_string   string to parse
    -- %param   i_length   the length of each output line
    --------------------------------------------------------------------
    PROCEDURE pl (i_string IN VARCHAR2, i_length IN PLS_INTEGER := 80)
    IS
        l_len     PLS_INTEGER := LEAST (i_length, 255);
        l_len2    PLS_INTEGER;
        l_chr10   PLS_INTEGER;
        l_str     VARCHAR2 (2000);

    BEGIN
        IF LENGTH (i_string) > l_len
        THEN
            l_chr10 := INSTR (i_string, CHR (10));

        IF l_chr10 > 0 AND l_len >= l_chr10
        THEN
            l_len := l_chr10 - 1;
            l_len2 := l_chr10 + 1;
        ELSE
            l_len2 := l_len + 1;
        END IF;

        l_str := SUBSTR (i_string, 1, l_len);
        DBMS_OUTPUT.put_line (l_str);
        pl (i_string   => SUBSTR (i_string, l_len2)
           ,i_length   => i_length);
    ELSE
        DBMS_OUTPUT.put_line (i_string);
    END IF;

    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.enable (1000000);

            IF
                l_str IS NULL
            THEN
                DBMS_OUTPUT.put_line (i_string);
            ELSE
                DBMS_OUTPUT.put_line (l_str);
            END IF;
    END pl;


    --------------------------------------------------------------------
    -- PURPOSE: handles CLOB data
    --          Overloaded procedure
    --
    -- %param   i_clob     clob data to parse
    -- %param   i_length   the length of each output line
    --------------------------------------------------------------------
    PROCEDURE pl (i_clob IN CLOB, i_length IN PLS_INTEGER := 80)
        IS
            l_buffer     VARCHAR2 (255);
            l_amount     PLS_INTEGER := GREATEST (i_length, 255);
            l_position   INTEGER := 1;
        BEGIN
            LOOP
                SYS.DBMS_LOB.read ( clob_in
                                   ,l_amount
                                   ,l_position
                                   ,l_buffer);
                /* Display the buffer contents using the string overloading */
                pl (l_buffer);
                l_position := l_position + l_amount;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND OR VALUE_ERROR
            THEN
                pl ('** End of CLOB data **');
    END pl;

    --------------------------------------------------------------------
    -- PURPOSE: converts boolean value to string
    --          Overloaded procedure
    --
    -- %param   i_bool_val   Boolean value to convert
    --------------------------------------------------------------------
    PROCEDURE pl (i_bool_val IN BOOLEAN)
    IS
    BEGIN
        pl (strval (i_bool_val));
    END pl ;

    --------------------------------------------------------------------
    -- PURPOSE: converts a variable string to a nested-table type 
    --          that can be used in an SQL statement
    --
    -- %param   i_string   comma-delimited IN list
    --
    -- usage
    --    SELECT *
    --    FROM   TABLE 
    --                ( SELECT CAST( 
    --                               parse_list('abc, xyz, 012')
    --                                  AS parse_list_tt 
    --                             ) 
    --                  FROM dual 
    --               )
    --
    -- dependency: type_parse_list_t
    --------------------------------------------------------------------
    FUNCTION parse_list ( string_in VARCHAR2 )
        RETURN   parse_list_t
    AS
         -- append ',' to the end of the string
         l_string        varchar2(256) default i_string || ','   ;
         l_data          parse_list_t   :=    parse_list_t()      ;
         l_num           number                                   ;

   BEGIN
       LOOP
           EXIT WHEN l_string is null ;

           -- find the next occurence of ','
           l_num := instr( l_string, ',' ) ;

           -- we found a ',' so lets extend our variable to hold our new string value
           l_data.EXTEND                                          ;
           l_data(l_data.COUNT) :=
                   TRIM (
                      SUBSTR(   -- we don't want the trailing comma
                              l_string, 1,   l_num - 1
                        )
                        ) ;

           -- we don't want the leading comma
           l_string := substr( l_string,   l_num + 1 ) ;

       END LOOP ;

       RETURN l_data ;

   END parse_list ;

    --------------------------------------------------------------------
    -- PURPOSE: Checks to see if a number_in is a valid number (number may
    --          inlude a dot (.) and a negative sign (-)
    -- %param   i_number   number to validate
    -- %return  boolean    True if valid number, otherwise False
    --------------------------------------------------------------------
   FUNCTION is_number ( i_number    IN   VARCHAR2 )
       RETURN   BOOLEAN
   IS
      l_ret      varchar2(10) ;
      l_retval   boolean ;
   BEGIN
       select decode(REGEXP_INSTR (i_number, '[^[:digit:].-]'),0,'NUMBER','NOT_NUMBER')
       into   l_ret
       from   dual;

       IF   ( l_ret = 'NUMBER' )
       THEN
              l_retval := TRUE ;
       ELSE
              l_retval := FALSE ;
       END IF ;

       RETURN l_retval ;

   END is_number ;

   --------------------------------------------------------------------
   -- PURPOSE: Checks to see if i_date is a valid date ( based on
   --          i_date_format )
   -- %param   i_date            date to validate
   -- %param   i_date_format     date format
   -- %return  boolean           True if valid date, otherwise False
   --------------------------------------------------------------------
   FUNCTION is_date (   i_date          IN   VARCHAR2
                      , i_date_format   IN   VARCHAR2   DEFAULT 'DD-MON-RR'
                    )
       RETURN BOOLEAN
   IS
       l_dt   DATE;
   BEGIN
       l_dt := TO_DATE(i_date,i_date_format) ;
       RETURN   TRUE ;

       EXCEPTION
           WHEN   value_error
           THEN
                  RETURN FALSE ;

   END is_date ;

   --------------------------------------------------------------------------------
   -- PURPOSE: Checks to see if i_col_list contains valid column names owned 
   --          by i_owner
   -- %param   col_list_in   list of column names to validate against all_tab_cols
   -- %return  boolean
   --------------------------------------------------------------------------------
   FUNCTION is_column_list_valid(   i_col_list   IN   VARCHAR2
                                  , i_owner      IN   VARCHAR2
                                  , i_delimiter  IN   VARCHAR2   DEFAULT ',')
                                 )
       RETURN   BOOLEAN
   IS
       l_string           varchar2(32767) := UPPER(i_col_list) || ',' ;
       l_owner            varchar2(30)    := UPPER(i_owner)           ;
       n                  number          := 0 ;
       l_delimiter        varchar2(1)     := i_delimiter ;
       l_piece            varchar2(30) ;
       l_retval           boolean := TRUE ;
       l_place_holder     boolean ;

       FUNCTION col_exist( i_col_name IN varchar2)
           RETURN BOOLEAN
       IS
           l_retval BOOLEAN ;
           l_cnt    NUMBER  ;
       BEGIN
           SELECT   count(*)
             INTO
                    l_cnt
            FROM
                    all_tab_cols
           WHERE
                    owner = i_owner
            AND
                    column_name = i_col_name  ;

           IF   ( l_cnt > 0 )
           THEN
                  l_retval := TRUE  ;
           ELSE
                  l_retval := FALSE ;
           END IF ;

           RETURN l_retval ;

       END ;

   BEGIN
       LOOP
           EXIT WHEN ( l_string IS NULL OR l_retval = FALSE OR l_retval IS NULL ) ;

           -- find first occurrence of a comma in l_string
           n := INSTR(l_string,l_delimiter) ;

           -- parse column name and include any aliases
           l_piece := UPPER(TRIM(SUBSTR(l_string,1,n-1)));

           -- parse out aliases to get the actual column name
           IF   ( INSTR(l_piece,' ') > 0 )
           THEN
                  l_piece := UPPER(TRIM(SUBSTR(l_piece,1,INSTR(l_piece,' ')-1)));
           END IF ;

           IF   ( INSTR(l_piece,'.') > 0 )
           THEN
                  l_piece := UPPER(TRIM(SUBSTR(l_piece,INSTR(l_piece,'.')+1)));
           END IF ;

           -- call private function
           l_place_holder := col_exist(l_piece) ;

           IF   ( l_place_holder = FALSE )
           THEN
                  l_retval := FALSE ;
           END IF ;

           -- move to the next column name in the list
           l_string := TRIM(SUBSTR(l_string,n+1));

       END LOOP ;

       RETURN l_retval ;

   END is_column_list_valid ;
   

   --------------------------------------------------------------------------------
   -- PURPOSE: Return the OS_USER and IP_ADDRESS from SYS_CONTEXT
   -- %return  varchar2
   --------------------------------------------------------------------------------
   FUNCTION set_client_identifier
       RETURN varchar2
   IS
       l_retval varchar2(64) ;
   BEGIN
       SELECT   sys_context( 'userenv'
                             ,'os_user'
                           ) || ':' ||
                sys_context( 'userenv'
                            ,'ip_address'
                           )
       INTO     l_retval
       FROM     dual ;

   RETURN NVL(l_retval,'USERENV not available') ;

   END set_client_identifier ;


   --------------------------------------------------------------------------------
   -- PURPOSE: Convert raw data to the appropriate data type
   --          this is particularly useful for all_tab_col_statistics
   -- %param   i_rawval      raw data to be converted from
   -- %param   i_type        data type to converted to
   -- %return  varchar2
   -- EXAMPLE:
   -- <CODE>
   --    select a.column_name,
   --           pkg_utility.convert_raw(a.low_value,b.data_type)  as low_val ,
   --           pkg_utility.convert_raw(a.high_value,b.data_type)  as high_val ,
   --           b.data_type
   --    from   all_tab_col_statistics  a, all_tabl_cols  b
   --    where  a.owner = &owner
   --    and    b.owner = &owner
   --    and    a.table_name = &table_name
   --    and    a.table_name = b.table_name
   --    and    a.column_name = b.column_name ;
   -- </CODE>
   --------------------------------------------------------------------------------
   FUNCTION convert_raw(   i_rawval   IN   RAW
                         , i_type     IN   VARCHAR2 )
       RETURN varchar2
   IS
       n        number;
       vc       varchar2(32767);
       dt       date;
       nvc      nvarchar2(32767);
       ri       rowid;
       ch       char(32767);
       bd       binary_double;
       bf       binary_float;
   BEGIN
       if (i_type = 'NUMBER')
       then
             dbms_stats.convert_raw_value(rawval_in, n);
             vc := to_char(n) ;
       elsif (i_type = 'VARCHAR2')
       then
             dbms_stats.convert_raw_value(rawval_in, vc);
       elsif (i_type = 'DATE')
       then
              dbms_stats.convert_raw_value(rawval_in, dt);
              vc := to_char(dt) ;
       elsif (i_type = 'NVARCHAR2')
       then
              dbms_stats.convert_raw_value_nvarchar(rawval_in, nvc);
              vc := nvc ;
       elsif (i_type = 'ROWID')
       then
              dbms_stats.convert_raw_value_rowid(rawval_in, ri);
              vc := to_char(ri) ;
       elsif (i_type = 'CHAR')
       then
              dbms_stats.convert_raw_value(rawval_in, ch);
              vc := ch ;
       elsif (i_type = 'BINARY DOUBLE')
       then
              dbms_stats.convert_raw_value(rawval_in, bd);
              vc := to_char(bd) ;
       elsif (i_type = 'BINARY FLOAT')
       then
              dbms_stats.convert_raw_value(rawval_in, bf);
              vc := to_char(bf) ;
       else
              vc := 'UNKNOWN DATATYPE';
       end if;


       RETURN vc ;

   END convert_raw ;

END pkg_utility ;
/
show errors package body wiir.pkg_utility
