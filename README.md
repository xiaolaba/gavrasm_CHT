gavrasm_CHT

Originator and credits,
http://www.avr-asm-tutorial.net/gavrasm/index_en.html#source

it is assembler for AVR MCU, open source, available for download. My attempt to build avr mcu bootloader to uses with this tool, and then a try of the locale support to display Traditional Chinese language. Traditional Chinese Language support (CHT or BIG5).

(side issue, github web editor, no new line was allowed !? add two spaces to each end of line, then press ENTER, will do the job and displyed as a new line desired, see https://stackoverflow.com/questions/24575680/new-lines-inside-paragraph-in-readme-md)

### Notes ###
  xiaolaba, 2017-sep-18, Traditional Chinese Language interface (CHT)  
  source code file format, UTF-8-BOM,  
  file editor used: https://notepad-plus-plus.org/  
  Windows 10, CHT/BIG5, codepage 950  
  Console output: no proper CHT characters set display ! except English string  
  ASM listing : BIG5 characters set is able to display properly with win10 and editor used.  

  
  
### how to: ###
Win10 64 bits, CHT/BIG5

1) download & install Free Pascal, today, 3.0.2, https://sourceforge.net/projects/freepascal/files/Win32/3.0.2/fpc-3.0.2.i386-win32.exe/download, the user interface is a littel bit mess of display with Win10 CHT
```c++
To embeds image to this read.me
![alt text](http://url/to/img.png)  
https://github.com/xiaolaba/gavrasm_CHT/blob/master/FPC3.0.2_screen.jpg
```
![alt text](https://github.com/xiaolaba/gavrasm_CHT/blob/master/FPC3.0.2_screen.jpg)


2) download gavrsam, the source code, today, version 3.6, http://www.avr-asm-tutorial.net/gavrasm/index_en.html#source, (hopefuly the author will counts and release update for this user string port soon or later)


3) download <a href="https://github.com/xiaolaba/gavrasm_CHT/blob/master/gavrlang_cht.pas">gavrlang_cht.pas</a>, from this respostory, rename to gavrlang.pas, then copy to folder of the source code



4) open Free Pascal, open the gavrasm.pas, hit F9 to compile this AVR assembler tool, <a href="https://github.com/xiaolaba/gavrasm_CHT/files/1309746/gavrasm_cht.zip">gavrasm_cht.exe in zip</a> is about 6MB

5) uses command line, gavrasm -h, will display simple help manual
```c++
gavrasm -h
```



6) download test.asm from this repository, it is provided courtesy by the author, gavrasm test.asm will generates two files, test.hex & test.lst  
<a href="https://github.com/xiaolaba/gavrasm_CHT/blob/master/test.asm">test.asm</a>  
<a href="https://github.com/xiaolaba/gavrasm_CHT/blob/master/test.lst">test.lst</a>  
<a href="https://github.com/xiaolaba/gavrasm_CHT/blob/master/test.hex">test.hex</a>  

7) console output is not be able to display BIG5 char properly, do not know why, uses notepad++ to open test.lst it is fine and display in proper.
```c++
To embeds image to this read.me
![alt text](http://url/to/img.png)  
https://github.com/xiaolaba/gavrasm_CHT/blob/master/console_problem.jpg
```
![alt text](https://github.com/xiaolaba/gavrasm_CHT/blob/master/console_problem.jpg)
