setup() {
 
    # Use common setup from file
    load 'test_helper/common-setup'
    _common_setup
 
    # Store original hostname
    VMhostname=$(hostname)
 
    # First character of test hostname cannot be -
    hostNameStartEnd=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w $((1)) | head -n 1)
 
    # Create output.sh without exits
    echo '' > $PROJECT_ROOT/src/output.sh
    chmod a+x $PROJECT_ROOT/src/output.sh
    sed "s/exit//" $PROJECT_ROOT/src/task1.sh > $PROJECT_ROOT/src/output.sh
 
    # Make copy of hostfile
    mv /etc/hosts /etc/realHosts
    cp /etc/realHosts /etc/hosts
    fakeHost=/etc/hosts
 
}
 
@test "Hostname has acceptable characters and length" {
   
    # Set new hostname
    goodHostNameMiddle=$(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((1 + $RANDOM % 11)) | head -n 1)
    goodHostName=$hostNameStartEnd$goodHostNameEnd$hostNameStartEnd
    hostname $goodHostName
 
    # Run
    run task1.sh
 
    # Check
    assert_output --partial 'SUCCESS. Hostname characters are appropriate'
    assert_output --partial 'SUCCESS. Hostname length less than or equal to 13 characters'
 
}
 
@test "Hostname has acceptable characters but not length" {
 
    # Set new hostname
    badLengthEnd=$(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((13 + $RANDOM % 50)) | head -n 1)
    badLength=$hostNameStartEnd$badLengthEnd$hostNameStartEnd
    hostname $badLength
 
    # Run
    run task1.sh
 
    # Check
    assert_output --partial 'SUCCESS. Hostname characters are appropriate'
    assert_output --partial 'ERROR. Hostname length longer than 13 characters'
 
}
 
@test "Hostname has acceptable length but not characters" {
 
    # Set new hostname
    badCharacters=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w  $((1 + $RANDOM % 13)) | head -n 1)
    hostname $badCharacters
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'ERROR. Hostname contains characters outside of 0-9, a-z, -'
    assert_output --partial 'SUCCESS. Hostname length less than or equal to 13 characters'
 
}
 
@test "Hostname has unacceptable characters and length" {
 
    # Set new hostname
    badHostName=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w  $((14 + $RANDOM % 50)) | head -n 1)
    hostname $badHostName
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'ERROR. Hostname contains characters outside of 0-9, a-z, -'
    assert_output --partial 'ERROR. Hostname length longer than 13 characters'
 
}
 
@test "There is a /etc/hosts file" {
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'SUCCESS. Found /etc/hosts file'
 
}
 
@test "There is no /etc/hosts file" {
 
    # Change name of /etc/hosts
    mv /etc/hosts /etc/testsample
 
    # Update variable
    fakeHost=/etc/testsample    
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'ERROR. No /etc/hosts file'
 
}
 
@test "There is no entry in /etc/hosts" {
 
    # Run
    run output.sh    
 
    # Check
    assert_output --partial 'ERROR. There is NOT an entry in /etc/hosts for the localhost'
 
}
 
@test "There is an entry in /etc/hosts and the entry follows the proper format" {
 
    # Add proper entry to /etc/hosts file
    echo "$(hostname -i) $(hostname).$(echo $RANDOM | md5sum | head -c 10).$(echo $RANDOM | md5sum | head -c 10) $(hostname)" >> /etc/hosts
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'SUCCESS. Entry follows the format (IP, FQDN, Hostname)'
 
}
 
@test "There is an entry but the entry in /etc/hosts does not follow proper format" {
 
    # Add improper entry to /etc/hosts file
    echo "$(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((10 + $RANDOM % 15)) | head -n 1) $(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((10 + $RANDOM % 15)) | head -n 1) $(hostname)" >> /etc/hosts
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'ERROR. Entry does not follow the format (IP, FQDN, Hostname)'
 
}
 
@test "There is an incorrect entry in /etc/hosts but it is commented out" {
 
    # Add commented out incorrect entry to /etc/hosts
    echo "#$(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((10 + $RANDOM % 15)) | head -n 1) $(cat /dev/urandom | tr -dc 'a-z0-9-' | fold -w $((10 + $RANDOM % 15)) | head -n 1) $(hostname)" >> /etc/hosts
 
    # Run
    run output.sh
 
    # Check
    assert_output --partial 'ERROR. There is NOT an entry in /etc/hosts for the localhost'
 
}
 
teardown() {
 
    # Restore original hostname
    hostname $VMhostname
 
    # Delete output.sh
    rm $PROJECT_ROOT/src/output.sh
 
    # Restore hostfile
    rm $fakeHost
    mv /etc/realHosts /etc/hosts
 
}
