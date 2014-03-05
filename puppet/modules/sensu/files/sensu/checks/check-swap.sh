#!/bin/bash
# This script validates
#
# Swap memory usage on a machine
# 
# No machine should never ever swap anything! (following the old saw: "Memory is RAM!")
#
# usage: "check_swap -w WARNING(INTEGER in MBytes) -c CRITICAL(INTEGER in MBytes)"
# 
# WARNING < CRIT
# 
# Returns the nagios native status codes as defined in:
#
# Nagios Status
#
# 0 = OK (SWAP usage below WARNING)
# 1 = WARNING (SWAP usage between WARNING AND CRITICAL)
# 2 = CRITICAL (SWAP usage higher than CRITICAL)
# 3 = UNKNOWN (Wrong usage)
#
# * 20111028 - initial release by Daniel Klockenkaemper <dk@marketing-factory.de>

## USAGE MESSAGE
usage() {
cat << EOF
usage: $0 options

This script runs a Swap test on a machine.

OPTIONS:
   -h      Show this message
   -w      Warning Level in MBytes (not optional)
   -c      Critical Level in MBytes (not optional)

Warning Level should be lower than Critical Level!

EOF
}

SWAP_WARN=
SWAP_CRIT=

## FETCH ARGUMENTS
while getopts "hw:c:" OPTION; do

        case "${OPTION}" in
                h)
                        usage
                        exit 3
                        ;;
                w)
                        SWAP_WARN=${OPTARG}
                        ;;
                c)
                        SWAP_CRIT=${OPTARG}
                        ;;
                ?)
                        usage
                        exit 3
                        ;;
        esac

done

## CHECK ARGUMENTS
if [ -z ${SWAP_WARN}  ] || [  -z ${SWAP_CRIT} ] || [ ${SWAP_WARN} -gt ${SWAP_CRIT} ] ; then

        usage
        exit 3

fi

## GET SWAP INFO FROM MACHINE
TOTAL_SWAP=$(free -m | grep Swap | awk '{print $2}')
USED_SWAP=$(free -m | grep Swap | awk '{print $3}')
FREE_SWAP=$(free -m | grep Swap | awk '{print $4}')

## CHECK SWAPPING ON MACHINE
if [ ${USED_SWAP} -lt ${SWAP_WARN} ]; then

		## SWAP IS OK
        LINE="SWAP OK! Total Swap: ${TOTAL_SWAP}MB , used Swap ${USED_SWAP}MB , free Swap ${FREE_SWAP}MB."
        COUNT=`echo $LINE | awk '{print $9}'`
        echo $LINE \| swap_used=$COUNT\;${SWAP_WARN}\;${SWAP_CRIT}\;0\;
		exit 0

elif [ ${USED_SWAP} -gt ${SWAP_WARN} ] && [ ${USED_SWAP} -lt ${SWAP_CRIT} ] || [ ${USED_SWAP} -eq ${SWAP_WARN} ]; then

		## SWAP IS IN WARNING STATE
        LINE="SWAP WARNING! Total Swap: ${TOTAL_SWAP}MB , used Swap ${USED_SWAP}MB , free Swap ${FREE_SWAP}MB."
		COUNT=`echo $LINE | awk '{print $9}'`
        echo $LINE \| swap_used=$COUNT\;${SWAP_WARN}\;${SWAP_CRIT}\;0\;
		exit 1

elif [ ${USED_SWAP} -gt ${SWAP_CRIT} ] || [ ${USED_SWAP} -eq ${SWAP_CRIT} ]; then
		
		## SWAP IS IN CRITICAL STATE
        LINE="SWAP CRITICAL! Total Swap: ${TOTAL_SWAP}MB , used Swap ${USED_SWAP}MB , free Swap ${FREE_SWAP}MB."
		COUNT=`echo $LINE | awk '{print $9}'`
        echo $LINE \| swap_used=$COUNT\;${SWAP_WARN}\;${SWAP_CRIT}\;0\;
        exit 2

else
		
		## SHOULD NEVER REACH THIS POINT, MUST BE USAGE :)
        usage
        exit 3

fi


