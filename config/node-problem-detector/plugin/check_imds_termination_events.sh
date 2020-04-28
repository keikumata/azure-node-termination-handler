#!/bin/bash
OK=0
NONOK=1

# Assuming this binary exists
azure-node-termination-handler
if [ $? -ne 0 ]; then
    echo "IMDS has a scheduled event for termination"
    exit $NONOK
fi

echo "IMDS has no scheduled events for termination"
exit $OK
