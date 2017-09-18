# gavrasm_CHT
a try and port the some user strings with Traditional Chinese Language support (CHT or BIG5)  

try to build avr mcu bootloader, the tool and avaialbe for fownload, try the locale support for Traditional Chinese language support

Originator and credits,
http://www.avr-asm-tutorial.net/gavrasm/index_en.html#source


####
  xiaolaba, 2017-sep-18, Traditional Chinese Language interface (CHT)
  source code file format, UTF-8-BOM, 
  file editor used: https://notepad-plus-plus.org/
  Windows 10, CHT/BIG5, codepage 950
  Console output: no proper CHT characters set display ! except English string
  ASM listing : BIG5 characters set is able to display properly with win10 and editor used.

  
  
how to:
Win10 64 bits, CHT/BIG5

1) download & install Free Pascal, today, 3.0.2, https://sourceforge.net/projects/freepascal/files/Win32/3.0.2/fpc-3.0.2.i386-win32.exe/download, the user interface is a littel bit mess of display with Win10 CHT


2) download gavrsam, the source code, today, version 3.6, http://www.avr-asm-tutorial.net/gavrasm/index_en.html#source, (hopefuly the author will counts and release update for this user string port soon or later)

3) download gavrlang_cht.pas from this respostory, remname to gavrlang.pas, then copy to folder of the source code

4) open Free Pascal, open the gavrasm.pas, hit F9 to compile the tools, gavrasm.exe is about 6MB

5) uses command line, gavrasm -h, will display simple help manual
```c++
gavrasm -h
```



6) download test.asm from this repository, it is provided courtesy by the author, gavrasm test.asm will generates two files, test.hex & test.lst

7) console output is not be able to display BIG5 char properly, do not know why, uses notepad++ to open test.lst it is fine and display in proper.
