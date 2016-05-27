#!/bin/bash
NEEDLE="Starting listening for CQL clients"
HAYSTACK="/var/log/cassandra/system.log"
COUNTER=0
FOUND=0
while ! grep "${NEEDLE}" ${HAYSTACK}
do
    if [ "$COUNTER" -gt 15 ]
    then
        FOUND=1
        break
    fi
    COUNTER=$((COUNTER+1))
    echo "Not found. Sleeping for 10"
    sleep 10;
done
exit $FOUND
