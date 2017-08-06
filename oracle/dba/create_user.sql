-- ********************************************************************
-- * Filename           : create_user.sql
-- * Author             : Jess Brock
-- * Original		        : 17-NOV-2012
-- * Last Modified	    : 17-NOV-2012
-- * Description	      : Create a user with a:
-- *					            1. Role
-- *					            2. Default tablespace
-- *			  		          3. Temporary tablespace
-- *					            4. Profile
-- * Usage		: start create_user <un> <pd> <dflt tbs> <tmp tbs> <prof>
-- ********************************************************************


def uid	    = &&1
def passwd	= &&2
def dts		  = &&3
def dtts	  = &&4
def prof	  = &&5

create user 		        &uid
  identified by 	      &passwd
  default tablespace 	  &dts 
  temporary tablespace 	&dtts
  profile		            &prof
/

alter user &uid quota 0 on system;

alter user &uid quota unlimited on &dts;
  
grant connect to &uid;

undef uid
undef passwd
undef dts
undef dtts
undef prof
start clear
