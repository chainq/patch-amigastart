export PATH=$PATH:$HOME/DevPriv/m68k-amiga-binutils
FPC=$HOME/DevPriv/fpc-bin/m68k-amiga-020/lib/fpc/3.3.1

$FPC/ppcross68k -XV -Xs -Tamiga -al -B -O2 -Avasm -Cp68020 -Fu$FPC/units/m68k-amiga/* testcode.pas
./patchmaker.sh

# build the patcher for Amiga
$FPC/ppcross68k -XV -Xs -Tamiga -al -B -O2 -Avasm -Cp68020 -Fu$FPC/units/m68k-amiga/* patchas.pas

# build for the host platform
#fpc patchas.pas
