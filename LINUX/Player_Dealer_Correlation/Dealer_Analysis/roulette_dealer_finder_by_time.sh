#!/bin/bash
#hour: hh:00 Date:mmdd

echo "Date: "$1""
awk -F" " '{print $1, $2, $5, $6}' *$1* | grep $2 | grep -i $3
 


