#!/bin/bash


# Create test directory

mkdir /bats-tests
mkdir /bats-tests/bats-files



# Clone desired bats repositories into helper folder

cd /bats-tests/bats-files

git clone https://github.com/bats-core/bats-core.git

git clone https://github.com/bats-core/bats-support.git

git clone https://github.com/bats-core/bats-assert.git



# Add bats-core to PATH

cd bats-core

./install.sh /usr/local



# Set up filesystem in /bats-tests

mkdir /bats-tests/src
mkdir /bats-tests/test
mkdir /bats-tests/test/bats
mkdir /bats-tests/test/test_helper



# Copy files into filesystem

cd  /bats-tests/bats-files

cp -R bats-support /bats-tests/test/test_helper
cp -R bats-assert /bats-tests/test/test_helper
cp -a bats-core/. /bats-tests/test/bats

# cp ~/ORCA_Catalog/bats/*.bats /bats-tests/test
# cp ~/ORCA_Catalog/bats/*.bash /bats-tests/test/test_helper
# cp ~/ORCA_Catalog/bats/*.sh /bats-tests/src

cp $(rootPath)/*.bats /bats-tests/test
cp $(rootPath)/*.bash /bats-tests/test/test_helper
cp $(rootPath)/*.sh /bats-tests/src



# Give permissions to scripts
chmod -R 777 /bats-tests/src



# Test scripts
bats /bats-tests/test

# Uninstall BATS
cd /bats-tests/bats-files/bats-core
./uninstall.sh /usr/local

# Remove filesystem
rm -r /bats-tests
