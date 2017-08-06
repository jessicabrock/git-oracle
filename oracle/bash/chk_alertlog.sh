#!/bin/bash
#################################################
###### ALERT LOG CHECKING VIA ADRCI #############
#################################################
# Author : Jess Brock
# Version Date: 14-MAY-2015
# Usage :  
#    To run for last 24 hours - ./check_alert.sh [dbname]
# Edit variables below for moving between servers  
# reference: adrci> show alert -p "message_text like '%ORA-%' and originating_timestamp >= systimestamp-1" -term ;
#
DB=&1

if [[ -z "${DB// }" ]] # remove white space and check for zero-length
then
   echo "Usage: chk_alertlog.sh [dbname]"
   exit 1
fi

LOG=/home/oracle/bin/alertlog_check_daily.txt
EMAIL_SUBJECT="{$DB}:" 
EMAIL_LIST="<enter comma-delimited email list"

HOST_NAME=$(hostname -a)
  ############################################
  ###############DAILY CHECKS ################
  ###############DBMS CHECK###################
  ############################################
cd /home/oracle ;source /home/oracle/.bashrc
rm -f /home/oracle/bin/alert_log_check_daily.txt

  adrci_homes=( $(adrci exec="show homes" | grep -e rdbms ))
  echo "$(date)" >> $DAILY_LOG
  echo '####################################################' >> $LOG 
  echo '####### ALERT LOG OUTPUT FOR LAST 24 HOURS #########' >> $LOG
  echo '####################################################' >> $LOG 
  echo ''  >> $LOG 
  echo ''  >> $LOG 

  for adrci_home in ${adrci_homes[@]}
  do 
       echo $adrci_home' Alert Log' >> $LOG 
       adrci exec="set home ${adrci_home}; show alert -p \\\"message_text like '%ORA-%' and originating_timestamp > systimestamp-1\\\"" -term >> $LOG 
  done
 
  ############################################
  ############## DAILY CHECKS ################
  ############# LISTENER  CHECK###############
  ############################################ 

  adrci_lsnr_homes=( $(adrci exec="show homes" | grep -e tnslsnr))

  echo ''  >> $LOG 
  echo ''  >> $LOG 
  echo '####################################################' >> $LOG 
  echo '###### LISTENER LOG OUTPUT FOR LAST 24 Hours #######' >> $LOG
  echo '####################################################' >> $LOG 
  echo ''  >> $LOG 
  echo ''  >> $LOG 

  for adrci_lsnr_home in ${adrci_lsnr_homes[@]}
  do 
       echo $adrci_lsnr_home' Listener Log' >> $LOG 
       adrci exec="set home ${adrci_lsnr_home}; show alert -p \\\"message_text like '%TNS-%' and originating_timestamp > systimestamp-1\\\""  -term >> $LOG 
  done

  num_errors=`grep -c -e 'TNS-' -e 'ORA-' $LOG`

  if [ $num_errors != 0 ]
  then
       MAIL_SUBJ=$MAIL_SUBJECT$HOST_NAME" Errors Found in Daily Alert Log"
       mutt -a $LOG -s "$MAIL_SUBJ" $EMAIL_LIST < /home/oracle/bin/message.txt
  fi
  exit 0