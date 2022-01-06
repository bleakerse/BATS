#!/usr/bin/env bash
 
#======================================================================
# TASK
#   Validate RAM size
 
# DETAILS
#   When host has more memory than required. This should be warning.
#   When host has less memory than required. This should be an error.
#   When host has equal memory than required. This should be pass.
 
 
# INFORMATION
#  Take input from user. After that check the conditions for RAM size.
#======================================================================
 
# Take input of required RAM by user
if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -gt 0 ]
then
      echo "SUCCESS. User has inputted RAM size"
      break
else
      echo "ERROR. User has inputted invalid RAM size"
      exit
fi
 
# Look for Host RAM size
actualVmSize=$(dmidecode -t 17 | grep "Size: [0-9]")
array=($actualVmSize)
 
totalRAM=0
 
for i in ${array[@]}
do
    if [[ $i =~ ^-?[0-9]+$ ]]
    then
        totalRAM=$((totalRAM + $i))
    fi
done
 
totalRAM=$((totalRAM / 1024))
echo "The host RAM size is $totalRAM GB"
 
# Compare user inputted required RAM to actual Host RAM size
if [ $totalRAM -eq $1 ]
then
    echo "SUCCESS. Host has equal memory required"
elif [ $totalRAM -lt $1 ]
then
    echo "ERROR. Host has less memory than required"
elif [ $totalRAM -gt $1 ]
then
    echo "WARNING. Host has more memory than required"
fi
