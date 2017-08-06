-- ********************************************************************
-- * Filename     : p_printv.sql
-- * Author       : Jess Brock (modified from Tom Kyte)
-- * Original	    : 08-Jun-2015
-- * Last Update  : 08-Jun-2015
-- * Description  : print output vertically down the screen (more readable)
-- * Usage        : exec printv('select name,value,default from v$parameter')
-- ********************************************************************

CREATE OR REPLACE PROCEDURE printv( i_query IN VARCHAR2 )
 AUTHID CURRENT_USER
is
    l_theCursor     integer default dbms_sql.open_cursor ;
    l_columnValue   varchar2(4000) ;
    l_status        integer ;
    l_descTbl       dbms_sql.desc_tab ;
    l_colCnt        number(8) ;
    l_cnt           number := 0 ;
begin
    EXECUTE IMMEDIATE 'alter session set nls_date_format = ''dd-mon-yyyy hh24:mi:ss''';

    dbms_sql.parse(  l_theCursor,  i_query, dbms_sql.native ) ;
    dbms_sql.describe_columns
    ( l_theCursor, l_colCnt, l_descTbl ) ;

    for i in 1 .. l_colCnt loop
        dbms_sql.define_column
        (l_theCursor, i, l_columnValue, 4000) ;
    end loop ;

    l_status := dbms_sql.execute(l_theCursor) ;

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
       loop
          for i in 1 .. l_colCnt
             loop
                dbms_sql.column_value
                   ( l_theCursor, i, l_columnValue ) ;

                dbms_output.put_line
                   (substr( rpad( l_descTbl(i).col_name, 30 )
                      || ': ' ||
                         l_columnValue, 1, 255 ) ) ;

             end loop;

          l_cnt := l_cnt + 1 ;
          dbms_output.put_line( '----------' || l_cnt ||'----------' ) ;

       end loop;
       
       EXECUTE IMMEDIATE 'alter session set nls_date_format = ''dd-MON-rr hh24:mi''';

exception
    when others then
      EXECUTE IMMEDIATE 'alter session set nls_date_format = ''dd-MON-rr hh24:mi''';
      dbms_output.put_line( 'print_table' || chr(10) || sqlerrm ) ;
      raise ;
end printv ;
/