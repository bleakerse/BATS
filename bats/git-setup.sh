#!/bin/bash

# Store branch name
branchName=$1



# Check if there was an argument
if [ -z $branchName ] 
then
    echo 'ERROR. User has not included a branch name as an argument'
    exit
fi



# Install git

zypper install git



# Clone repository with ORCA catalog

cd ~

git clone eysapcto@vs-ssh.visualstudio.com:v3/eysapcto/EY%20SAP%20on%20Azure%20Cloud/ORCA_Catalog



# Checkout desired branch

cd ORCA_Catalog

git checkout $branchName

git pull