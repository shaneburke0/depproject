#!/bin/bash
# sburke 2014

# Level 1 functions <---------------------------------------


function isMySQLRunning {
        isRunning mysqld
        return $?
}

function isMySQLListening {
        isTCPlisten 3306
        return $?
}


# Level 0 functions <--------------------------------------

function isRunning {
PROCESS_NUM=$(ps -ef | grep "$1" | grep -v "grep" | wc -l)
if [ $PROCESS_NUM -gt 0 ] ; then
        echo $PROCESS_NUM
        return 1
else
        return 0
fi
}


function isTCPlisten {
TCPCOUNT=$(netstat -tupln | grep tcp | grep "$1" | wc -l)
if [ $TCPCOUNT -gt 0 ] ; then
        return 1
else
        return 0
fi
}

ERRORCOUNT=0

# Functional Body of monitoring script <----------------------------

isMySQLRunning
if [ "$?" -eq 1 ]; then
        echo MySQL process is Running
else
        echo MySQL process is not Running
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isMySQLListening
if [ "$?" -eq 1 ]; then
        echo MySQL is Listening
else
        echo MySQL is not Listening
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

if [ $ERRORCOUNT -gt 0 ]
then
        echo "There is a problem with MySQL"
	# log errors or send email
fi
