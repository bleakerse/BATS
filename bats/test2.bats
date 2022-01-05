setup() {
 
    # Use common setup from file
    load 'test_helper/common-setup'
    _common_setup
 
    # RAM size of VM
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
 
}
 
@test "If the user enters a number less than or equal to 0" {
 
    # Run
    run task2.sh $(expr $RANDOM \* -1)
 
    # Check
    assert_output --partial 'ERROR. User has inputted invalid RAM size'
 
}
 
@test "If the user enters a character" {
 
    # Run
    run task2.sh $(cat /dev/urandom | tr -dc 'a-zA-z' | fold -w $((1 + $RANDOM % 12)) | head -n 1)
 
    # Check
    assert_output --partial 'ERROR. User has inputted invalid RAM size'
   
}
 
@test "If the user enters an number greater than 0" {
 
    # Run
    run task2.sh $(expr $RANDOM + 1)
 
    # Check
    assert_output --partial 'SUCCESS. User has inputted RAM size'
 
}
 
@test "If the RAM is smaller than the user input" {
 
    # Run
    run task2.sh $(expr $totalRAM + 1)
 
    # Check
    assert_output --partial 'ERROR. Host has less memory than required'
 
}
 
@test "If the RAM is larger than the user input" {
 
    # Run
    run task2.sh $(expr $totalRAM - 1)
 
    # Check
    assert_output --partial 'WARNING. Host has more memory than required'
 
}
 
@test "If the RAM is equal to the user input" {
 
    # Run
    run task2.sh $totalRAM
 
    # Check
    assert_output --partial 'SUCCESS. Host has equal memory required'
 
}
 

