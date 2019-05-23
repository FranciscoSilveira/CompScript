librts_dir=""
#librts_dir="../libs/librts4-201602111900" # uncomment and edit this line if you're not using the VM
test_dir="../tests/"
log_file="results.txt"
common="[A-Z]-[0-9]{2}-[0-9]{1,3}-N-ok"

passed=0
failed=0
total=0

rm $log_file 2>/dev/null
make 1>/dev/null
if [[ $? != 0 ]]
then
	echo "Failed at compiling project" > "$log_file"
	exit
fi


for file in `find $test_dir -regextype posix-extended -regex ".*$common\.m19" | sort`
do
	total=$((total+1))

	filename=${file#$test_dir}
	expected=$test_dir"expected/"${filename%".m19"}".out"

	basename=${file%".m19"}
	asm_name=$basename".asm"
	unlinked_name=$asm_name".o"
	out_file=$basename".out"
	exec_name=$basename

	echo -e $filename >> $log_file
	rm $out_file 2>/dev/null

	./m19 $file -g -o $asm_name 2>/dev/null
	if [[ $? -ne 0 ]]
	then
		echo -e "\tFailed at compiling file\n" >> $log_file
		continue
	fi

	yasm $asm_name -felf32 -o $unlinked_name
	if [[ $? -ne 0 ]]
	then
		echo -e "\tFailed at generating assembly\n" >> $log_file
		continue
	fi

	if [[ -z $librts_dir ]]
	then
		ld -m elf_i386 $unlinked_name -o $exec_name -l rts
	else
		ld -m elf_i386 $unlinked_name -o $exec_name -L "$librts_dir" -l rts
	fi

	if [[ $? -ne 0 ]]
	then
		echo -e "\tFailed at linking\n" >> $log_file
		continue
	fi

	chmod +x $exec_name
	
	output="$($exec_name 2>/dev/null)"
	
	return_code=$?
	echo $output > $out_file
	
	differences="$(diff -w $out_file $expected)"
	if [[ -z $differences ]]
	then
		if [[ $return_code == 0 ]]
		then
			passed=$((passed+1))
			echo -e "\tPassed\n" >> $log_file
		else
			passed=$((passed+1)) 
			echo -e "\tOutput was correct, but return code was not 0\n" >> $logfile
		fi
	else
		failed=$((failed+1))
		echo -e "\tFailed:\n$differences\n" >> $log_file
	fi
done

echo "Passed $passed/$total"

log="$(cat $log_file)"
echo -e "Passed $passed/$total\n\n$log" > $log_file
