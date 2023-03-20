#!/bin/bash

# Pass all command-line arguments to mpirun and append the MILADY executable path
exec mpirun "$@" /MLD/mld_build_intel/bin/milady_main.exe
