#!/bin/bash
#
# depends on:
# - github.com/glaudiston/pragma_once
. $(dirname $(realpath $BASH_SOURCE --relative-to .))/pragma_once/bash/pragma_once.sh || return 0
#enable -f realpath realpath # use realpath as builtin wrapper to avoid excessive forking but it is commented because it does not support --relative-to option
shopt -s extdebug # Activate BASH_ARGV/BASH_ARGC variables
backtrace(){
	local caller_info;
	echo backtrace:
	local argc=0;
	local argv_pos=$argc;
	#echo "FULL BASH_ARGC = [${BASH_ARGC[@]}]"
	#echo "FULL BASH_ARGV = [${BASH_ARGV[@]}]"
	for ((i=0;;i++,argv_pos+=argc));do
		IFS=" " read -ra caller_info <<< $(caller $i);
		[ "$caller_info" == "" ] && break;
		local line="${caller_info[0]}"
		local funcname=${caller_info[1]-""};
		local ref_file="${caller_info[2]-""}";
		[ "$ref_file" != "" ] && script_file=$(realpath "${ref_file}" --relative-to .)
		argc=${BASH_ARGC[i+1]};
		local args_array=("${BASH_ARGV[@]:argv_pos:argc}")
		local reversed_args=()
		for (( j=argc-1; j>=0; j-- )); do
			reversed_args+=("${args_array[j]}")
		done
		args="${reversed_args[*]}"
		printf "%-10s\t%-4s %s\n" "$script_file:$line" "$funcname" "$args"
		#echo "debug point 1, i=$i; argv_pos=$argv_pos; argc=$argc; BASH_ARGC=${BASH_ARGC[@]}; [$(caller $i)]" >&2
	done|column -t -s $'\t'
}

