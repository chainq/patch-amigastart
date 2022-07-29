#!/usr/bin/env bash

set -o errexit

# Disassemble the right sections.
# This depends on the "named sections" feature of FPC,
# so testcode.o must be compiled with VASM

./m68k-elf-objdump -D -j ".text.n_p\$testcode_\$\$_orig_inttostr\$pointer\$longint\$\$pchar" testcode.o > testcode.dis.orig
./m68k-elf-objdump -D -j ".text.n_p\$testcode_\$\$_new_inttostr\$pointer\$longint\$\$pchar" testcode.o > testcode.dis.new

# Post process the disassemblies. Extract code in hex.

grep -A1000 "00000000" testcode.dis.orig | \
    tail -n+2 | grep -B1000 "88:" | cut -d $'\t' -f 2 >code_orig.txt
grep -A1000 "00000000" testcode.dis.new | \
    tail -n+2 | grep -B1000 "88:" | cut -d $'\t' -f 2 >code_new.txt

# Check if the code we extracted is OK compared to the original binary

diff code_orig.txt code_orig_binary.txt

# Convert the code into Pascal includes for the patcher.

while read -d" " f; do if [ -n "$f" ]; then echo -n -e "\$"$f"\n,"; fi; done <code_orig.txt >patch_orig.inc.tmp
echo >>patch_orig.inc.tmp
tail -r patch_orig.inc.tmp | tail -n +2 | tail -r >patch_orig.inc
rm patch_orig.inc.tmp

while read -d" " f; do if [ -n "$f" ]; then echo -n -e "\$"$f"\n,"; fi; done <code_new.txt >patch_new.inc.tmp
echo >>patch_new.inc.tmp
tail -r patch_new.inc.tmp | tail -n +2 | tail -r >patch_new.inc
rm patch_new.inc.tmp
