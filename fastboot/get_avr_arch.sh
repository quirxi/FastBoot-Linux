#!/bin/sh

# Get AVR architecture
#
# (c) 2010 Heike C. Zimmerer <hcz@hczim.de>
# License: PGL v3

# 2010-08-19: now runs gawk instead of awk.  WinAVR only knows about gawk.
# 2018-01-07: Adjust using shell buildins with gcc 4.9.2 by Malte Marwedel

usage(){
    echo "\
Usage: $pname -mmcu=<mcutype> <objfile.o>
Function: return AVR architecture (the
  architecture which avr-gcc uses for linking) as
  string on stdout.
  <mcutype> may be any mcu type accepted by avr-gcc.
  <objfile.o> must exist but may be empty.
Opts:
  -x   Script debug (set -x)"
    exit
}

pname="${0##*/}"
while getopts m:-:hx argv; do
    case $argv in
	m) mcu="$OPTARG";;
	x) set -x;;
	*) usage;;
    esac
done
shift $((OPTIND-1))

case "$#" in
    0) echo >&2 "$pname: missing object file"; exit 1;;
    1) ;;
    *) echo >&2 "$pname: Too many arguments: $*"; exit 1;;
esac

magic=";#magic1295671ghkl-."
# call gcc, asking it for the command line which it would use for
# linking:
# We want to extract the parameter after mmcu=
# for example -mmcu=avr4 -> avr4
# old command for <= gcc-4.5*
#set -- $(avr-gcc -m$mcu -### "$1" -o "$magic" 2>&1 \
#         | gawk '/^avr-gcc:/||/"-m".*'"$magic"'.*"-lgcc"/')
# new command for >= gcc-4.9*
V1=`avr-gcc -m$mcu -### "$1" -o "$magic" 2>&1 | grep COLLECT_GCC_OPTIONS`
V2=`echo ${V1#*mmcu=}`
V3=`echo ${V2%\'}`
echo $V3
exit 0

