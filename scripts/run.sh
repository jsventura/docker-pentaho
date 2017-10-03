#!/bin/bash

if [ ! -f ".pentaho_pgconfig" ]; then
   sh $PENTAHO_HOME/scripts/setup_postgresql.sh
   #HOSTNAME=$(`echo hostname`)

   sed -i "s/node1/${HOSTNAME}/g" $PENTAHO_HOME/pentaho-server/pentaho-solutions/system/jackrabbit/repository.xml
   touch .pentaho_pgconfig
fi

sh $PENTAHO_HOME/pentaho-server/start-pentaho.sh