# AmigaStart Patcher

AmigaStart is a small application that can show a colorful boot screen and system
information during an Amiga computer's boot sequence. It was written in 1995 by Ian J. Einman
and (it's available on Aminet)[http://aminet.net/package/util/boot/AmigaStart95_8].

The original code has an issue, where if the Amiga has more than 640MiB (or more
specifically more than 655350 KiB) of Fast Memory available, the number to string
conversion code breaks, and displays the wrong amount or just garbage instead.
This issue affects both emulators and high-end Amiga systems, where the amount of
Zorro III Fast Memory can be potentially more than this limit as the Zorro III bus
allows 1.5GiB of addressing range.

So I when as an experiment I expanded my Amiga 4000T beyond 640MiB, with the help
of to BigRAM Z3 and a ZZ9000, my boot screen was broken.

So I disassembled the app, found the error, fixed it, and wrote this quick & dirty
patcher application to correct it.

Some Twitter links documenting the entire "drama":

* https://twitter.com/chainq/status/1551841506889187328
* https://twitter.com/chainq/status/1551846304925499392
* https://twitter.com/chainq/status/1552790394483757057

# What and How

Contents of this repository:
* `testcode.pas` - test code, containing the original code disassembly and the fixed version
* `patchas.pas` - patcher code
* `build.sh` - script that builds the test code and the patcher
* `patchmaker.sh` - script that extracts the fixed function from the test code for inclusion in the patcher

Requirements to build the code:
* Free Pascal Compiler for Amiga
* `m68k-elf-objdump`
* the usual set of Un*x tools. The scripts were only tested on macOS.

# Disclaimer

Use at your own risk. Precisely zero warranty that any of this will work for you,
but for me it did. The contents of this repository are publised under WTFPL-2.

# F.A.Q

Q: I don't use AmigaStart, do I need this patcher?
A: No.

Q: I do use AmigaStart, but I don't have more than 640MiB Fast RAM, and probably never will, do I need this patcher?
A: No.

Q: Why did you write this in Pascal?
A: Because I wanted to.
