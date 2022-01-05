#!/usr/bin/env bash

#======================================================================
# TASK
#   Validate hostsfile

# DETAILS
#   To check if the hosts file contains entry for localhost.
#   The entries should follow the format (IP,FQDN,Hostname).
#   If entry is not maintained in this format then it should give error.

# INFORMATION
#   Hostfile - It is used to map domain names(hostnames) to IP addresses.
#   •   location of host-file on linux: cat /etc/hosts.
#   •   Hostname should contain only 0-9,a-z,-"
#   •   Length of hostname should be less than equal to 13 characters.
#======================================================================

# Verify host name characters
VMhostname=$(hostname)

if [[ $VMhostname =~ ^[0-9a-z-]+$ ]]
then
    echo "SUCCESS. Hostname characters are appropriate"
else
    echo "ERROR. Hostname contains characters outside of 0-9, a-z, -"
    exit
fi


# Verify host name length
lengthhostname=$(expr length $VMhostname)

if [ $lengthhostname -gt 13 ]
then
    echo "ERROR. Hostname length longer than 13 characters"
    exit
else
    echo "SUCCESS. Hostname length less than or equal to 13 characters"
fi

# Check if there is /etc/hosts file
if [ -f "/etc/hosts" ]
then
    echo "SUCCESS. Found /etc/hosts file"
else
    echo "ERROR. No /etc/hosts file"
fi

# Check for entry in /etc/hosts and if the entry follows the format (IP,FQDN,Hostname)
entry=$(grep -w $VMhostname /etc/hosts | sed '/^#/d')  
array=($entry)

if [ -z "$entry" ]
then
    echo "ERROR. There is NOT an entry in /etc/hosts for the localhost"
    exit
else
    echo "SUCCESS. There is an entry in /etc/hosts for the localhost"
    if [[ ${array[0]} =~ $(hostname -i) ]] && [[ ${array[1]} == $VMhostname.*.* ]] && [[ ${array[2]} == $VMhostname ]]
        then
            echo "SUCCESS. Entry follows the format (IP, FQDN, Hostname)"
        else
            echo "ERROR. Entry does not follow the format (IP, FQDN, Hostname)"
    fi
fi
