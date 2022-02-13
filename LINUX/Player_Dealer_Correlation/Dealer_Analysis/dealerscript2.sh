#! /bin/bash

cat 0310_Dealer_schedule | awk -F" " '{print $1, $2, $5,$6}'| grep '05:00:00 AM' >> Dealers_working_during_losses

