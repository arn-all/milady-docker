#!/bin/bash

if [[ "$1" != "shell" ]]; then
	# Pass all command-line arguments to mpirun and append the MILADY executable path
	exec mpirun "$@" /MLD/mld_build_intel/bin/milady_main.exe
else
	# start a terminal
	/bin/bash 
fi
