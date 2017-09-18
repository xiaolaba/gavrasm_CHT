{ English language source code file
  Exchange gavrlang.pas with this file to
  get the chinese version of the compiler,
  gavrasm version 3.7, last changed 09.09.2017
  
  xiaolaba, 2017-sep-18, Traditional Chinese Language interface (CHT)
  source code file format, UTF-8-BOM, 
  file editor used: https://notepad-plus-plus.org/
  Windows 10, CHT/BIG5, codepage 950
  Console output: no proper CHT characters set display ! except English string
  ASM listing : BIG5 characters set is able to display properly with win10 and editor used.
}
Unit gavrlang;

Interface

Var nMaxErr:Byte;

Function GetMsgM(nem:Byte):WideString;
Function GetMsgW(nem:Byte;s1,s2:WideString):WideString;
Function GetMsgE(nem:Byte;s1,s2:WideString):WideString;

Implementation

Uses gavrline;

Const
  nas=93;
  as:Array[1..nas] Of WideString=(
    {1} 'Unknown option on command line: 命令行上的未知選項: ',
    {2} 'Source file not found: 源文件未找到: ',
    {3} 'Error 錯誤 ',
    {4} 'File: 檔案:  ',
    {5} 'Line: 行號:  ',
    {6} 'Source line: 源碼行:  ',
    {7} 'Warning 警告 ',
    {8} 'List of symbols: 符號列表: ',
    {9} 'Type nDef nUsed Decimalval  Hexvalue Name 鍵入 nDef nUsed Decimalval Hexvalue Name ',
    {10} 'No symbols defined. 沒有符號定義 ',
    {11} 'List of macros: 巨集列表: ',
    {12} 'nLines nUsed nParams NamenLines nUsed nParams Name ',
    {13} '   No macros. 沒有巨集", ',
    {14} 'Including file 包括文件 ',
    {15} 'Continuing file 接續檔案 ',
    {16} ' lines done. 讀取完成 ',

    {17} 'Source file: 源碼       : ',
    {18} 'Hex file   : 燒錄檔     : ',
    {19} 'Eeprom file: EEPROM 檔案: ',
    {20} 'Compiled   : 編譯完畢   : ',
    {21} 'Pass       : 通過       : ',

    {22} 'Compiling 編譯中 ',
    {23} ' words code, 代碼字節, ',
    {24} ' words constants, total=常數字節, 總數 = ',
    {25} 'No warnings!沒有警告! ',
    {26} 'One warning!一個警告! ',
    {27} ' warnings!警告! ',

    {28} 'Compilation completed, no errors. 編譯完成無誤. ',
    {29} 'Program             : 程序       : ',
    {30} 'Constants           : 常數       : ',
    {31} 'Total program memory: 總程序長度 : ',
    {32} 'Eeprom space        : EEPROM 用量: ',
    {33} 'Data segment        : 數據       : ',
    {34} 'Compilation endet 編譯印記 ',

    {35} 'Compilation aborted, 退出編譯 ',
    {36} 'one error!一個錯誤! ',
    {37} ' errors! 錯誤 ',
    {38} ' Bye, bye ... 再見... ',
    {39} 'not even 非偶數 {偶數指令寄存器! } ',
    {40} ' \\ Instruction has no parameters!指令沒有參數! ',
    {41} 'register in the range from R0 to R31寄存器 R0 - R31 ',
    {42} 'bit value in the range from 0 to 7位元值 0-7 ',
    {43} 'relative jump address (label) in the range from -64 to +63 相對跳轉地址（標籤）的範圍從-64到+63 ',
    {44} 'absolute jump address (label), 16/22-bit-address 絕對跳轉地址（標籤）,16/22位地址 ',
    {45} 'none or register and Z or register and Z+無或寄存器, Z 或 Z+ ',
    {46} 'relative jump address (label) in the range +/- 2k相對跳轉地址（標籤）在+/- 2k範圍內, ',
    {47} 'register in the range from R16 to R31寄存器 R16 - R31 ',
    {48} 'double register R24, R26, R28 or R30雙寄存器 R24,R26,R28或R30 ',
    {49} 'lower port value between 0 and 31端口值 0 - 31 ',
    {50} 'register in the range from R16 to R23寄存器 R16 - R23 ',
    {51} 'even register (R0, R2 ... R30偶數寄存器（R0,R2 ... R30) ',
    {52} 'port value in the range from 0 to 63端口值 0 - 63 ',
    {53} 'X/Y/Z or X+/Y+/Z+ or -X/-Y/-ZX / Y / Z或X + / Y + / Z +或-X / -Y / -Z ',
    {54} 'Y+distance or Z+distance, range 0..63Y+偏移 或Z +偏移, 範圍 0..63 ',
    {55} '16-bit SRAM adress16位SRAM地址 ',
    {56} 'Constant in the range 0..63常量範圍 0..63 ',
    {57} 'Constant in the range 0..255常量範圍 0..255 ',
    {58} 'parameter 參數 ',
    {59} 'Internal compiler error! Please report to gavrasm@avr-asm-tutorial.net! 編譯器錯誤! 請通知 gavrasm@avr-asm-tutorial.net! ',
    {60} 'See the list of directives with gavrasm -d! 使用 gavrasm -d, 查看可用的指令列表  ',
    {61} 'List of supported directives 可用的指令列表" ',
    {62} '.BYTE x   : reserves x bytes in the data segment (see .DSEG). 在數據段中保留x個字節（請參閱.DSEG） ',
    {63} '.CSEG     : compiles into the code segment.CSEG: 編譯成代碼段 ',
    {64} '.DB x,y,z : inserts Bytes, chars or strings (.CSEG, ESEG).DB x,y,z: 插入位元組, 字符, 字串（.CSEG,ESEG） ',
    {65} '.DEF x=y  : symbol name x is attached to register y.DEF x = y: 符號名稱x 附加到寄存器y ',
    {66} '.DEVICE x : check the code for the AVR type x.DEVICE x: 檢查AVR類型 x 的代碼 ',
    {67} '.DSEG     : data segment, only labels and .BYTE directives.DSEG: 數據段,只有標籤和 .BYTE 指令 ',
    {68} '.DW x,y,z : insert words (.CSEG, .ESEG).DW x,y,z: 插入字節（.CSEG,.ESEG） ',
    {69} '.ELIF x   : .ELSE with condition x.ELIF x: .ELSE with condition x ',
    {70} '.ELSE     : alternative code, if .IF-condition was false.ELSE:替代代碼,如果.IF條件為false ',
    {71} '.ENDIF    : closes .IF resp. .ELSE or .ELIF .ENDIF:關閉.IF .ELSE或.ELIF ',
    {72} '.EQU x=y  : the symbol x is set to the constant value y 將符號x設置為常數值y ',
    {73} '.ERROR x  : forces an error with the message x 強制使用消息x ',
    {74} '.ESEG     : compiles to the Eeprom segment 編譯成Eeprom段, ',
    {75} '.EXIT [x] : closes source file, x is a logical expression. 關閉源文件,x是邏輯表達式 ',
    {76} '.IF x     : compiles the code, if x is true. 編譯代碼,如果x為真 ',
    {77} '.IFDEF x  : compiles the code if variable x is defined 編譯代碼如果變量x被定義 ',
    {78} '.IFDEVICE type: compiles the code if the type is correct 如果類型正確, 編譯代碼 ',
    {79} '.IFNDEF x : compiles the code if variable x is undefined 如果變量x未定義,則編譯代碼 ',
    {80} '.INCLUDE x: inserts the file "path/name" into the source 加入文件 ',
    {81} '.MESSAGE x: displays the message x 顯示訊息x ',
    {82} '.LIST     : switches list output on.LIST: 開啟列表功能 ',
    {83} '.LISTMAC  : switches list output for macros on 列印巨集 ',
    {84} '.MACRO x  : define macro named x 定義巨集名為x ',
    {85} '.ENDMACRO : closes the current macro definition (see .ENDM) 關閉當前的巨集定義（參見.ENDM） ',
    {86} '.ENDM     : the same as .ENDMACRO 等同.ENDMACRO ',
    {87} '.NOLIST   : switches list output off.NOLIST: 關閉列表功能 ',
    {88} '.ORG x    : sets the CSEG-/ESEG-/DSEG-counter to value x 將 CSEG-/ESEG-/DSEG- 設置為值x ',
    {89} '.SET x=y  : sets the variable symbol x to the value y 將變量符號x設置為值y ',
    {90} '.SETGLOBAL x,y,z: globalize the local symbols x, y and z 將本地符號x,y,z設為全局變數, ',
    {91} '.UNDEF x  : undefines the symbol x 未定義符號x ',
    {92} 'Constant in the range 0..15常量 0..15 ',
    {93} 'Pointer Z 指針Z '
	);

  nasw=11;
  asw:Array[1..nasw] Of WideString=(
    '001: %1 symbol(s) defined, but not used! 符號定義但未使用!',
    '002: More than one SET on variables(s)! 變量有一個以上的SET!',
    '003: No legal parameters found!無合法參數!',
    '004: Number of bytes on line is odd, added 00 to fit program memory!字節為奇數,添加00配合存儲器邊界!',
    '005: Data segment (%1 bytes) exceeds device limit (%2 bytes)!數據段 (%1 bytes) 超過設備限制 (%2 bytes)!',
    '006: No device defined, no syntax checking!沒有設備定義,沒有語法檢查!',
    '007: Wrap-around!四捨五入!',
    '008: More than one SET on global variable (%1)!全局變量 (%1) 上有多個 SET!',
    '009: Include defs not necessary, using internal values!不必要的的defs,使用內部值!',
    '010: Instruction set unclear, no documentation!指令集不清楚, 無文件!',
    '011: C-style instructions in file, lines ignored!文件中的C風格指令,忽略該行!'
	);

  nase=102;
  ase:Array[1..nase] Of WideString=(
    '001: Illegal character (%1) in symbol name! 符號名稱中的非法字符 (%1)!',
    '002: Symbol name (%1) is a mnemonic, illegal! 符號名稱 (%1) 是一個助記符, 非法!',
    '003: Symbol name (%1) not starting with a letter! 符號名 (%1) 不以字母開頭!',
    '004: Illegal character in binary value (%1)! 二進制值 (%1) 中的非法字符!',
    '005: Illegal character in hex value (%1)! 十六進制值中的非法字符 (%1)!',
    '006: Illegal character in decimal value (%1)! 十進制值中的非法字符 (%1)!',
    '007: Undefined constant, variable, label or device (%1)! 未定義的常量, 變量, 標籤或設備 (%1)!',
    '008: Unexpected = in expression, use == instead! 算式含有 = , 使用 == !',
    '009: Overflow of expression (%1) during shift-left(%2)! 左移 (%2) 運算溢出 (%1) !',
    '010: Overflow during multiplication (%1) by (%2)! (%1) 乘以 (%2) 乘法溢出 !',
    '011: Overflow during addition (%1) and (%2)! (%1) 和 (%2) 加法溢出!',
    '012: Underflow during subtraction (%2) from (%1)! (%2) - (%1) 無借位 !',
    '013: Unknown function %1! 未知功能%1!',
    '014: Illegal character (%1) in expression! 表達中的非法字符 (%1)!',
    '015: Missing opening bracket in expression! 表達式中缺少開頭的括號!',
    '016: Missing closing bracket in expression! 表達式中沒有關閉括號!',
    '017: Register value (%1) out of range (%2)! 寄存器值 (%1) 超出範圍 (%2) !',
    '018: Register value undefined! 寄存器值未定!',
    '019: Register value missing! 寄存器沒有賦值!',
    '020: Port value not valid! 端口值無效!',
    '021: Port value (%1) out of range (%2)! 端口值 (%1) 超出範圍 (%2) !',
    '022: Bit value (%1) out of range (0..7)! 位值 (%1) 超出範圍 (0..7) !',
    '023: Label (%1) invalid or out of range (%2)! 標籤 (%1) 無效或超出範圍 (%2) !',
    '024: Constant (%1) out of range (%2)! 常數 (%1) 超出範圍 (%2) !',
    '025: Expression of constant (%1) unreadable! 表達式 (%1) 不可讀!',
    '026: Constant invalid! 常數無效!',
    '027: %1 instruction can only use -XYZ+, not %2 %1指令只能使用-XYZ+ 而不是%2',
    '028: Missing X/Y/Z in %1 instruction! 在%1指令中缺少X / Y / Z!',
    '029: %1 instruction requires Y or Z as parameter, not %2! %1指令需要Y或Z作為參數, 而不是%2!',
    '030: Displacement (%1) out of range (%2)! 位移 (%1) 超出範圍 (%2) !',
    '031: Parameter X+d/Y+d missing! 未提供參數X + d / Y + d!',
    '032: ''+'' expected, but ''%1'' found! 預期 "+", 但出現 "%1" !',
    '033: Register and Z/Z+ expected, but %1 found! 預期寄存器 Z / Z+, 但出現 %1 !',
    '034: Register missing! 無寄存器!',
    '035: Illegal instruction (%1) for device type (%2)! 設備類型 (%2) 的非法指令 (%1) !',
    '036: Include file (%1) not found! 包含文件 (%1) 未找到!',
    '037: Name of Include file missing! 無包含文件的名稱!',
    '038: Error in parameter %1 (%2) in directive! 編譯指示參數%1 (%2) 出錯',
    '039: Missing "=" in directive! 編譯指示缺少 "="',
    '040: Name (%1) already in use for a %2! %2 的名稱 (%1) 已被使用',
    '041: Failed resolving right side of equation in EQU/SET/DEF! 在EQU / SET / DEF 中無法解析方程的右側',
    '042: Missing number of bytes to reserve! 缺少預留的字節數!',
    '043: Invalid BYTE constant! 無效的BYTE常數!',
    '044: Too many parameters, expected number of bytes only! 太多的參數, 只有預期的字節數!',
    '045: Missing ORG adress, no parameters! 缺少ORG的地址, 沒有參數!',
    '046: Origin adress (%1) points backwards in %2! 原始地址 (%1) 在%2 中向後點',
    '047: Undefined ORG constant! 未定義ORG常數!',
    '048: Too many parameters on ORG line, only adress! ORG線上的參數太多, 只需地址!',
    '049: No literals allowed in DW directive! Use DB instead! DW指令中不允許使用字面值!使用DB代替!',
    '050: No parameters found, expected words! 找不到參數, 需要雙字節WORD!',
    '051: Expected device name, no name found! 預期的設備名稱, 找不到名字!',
    '052: Device already defined! 設備已經定義!',
    '053: Unknown device, run gavrasm -T for a list of supported devices! 設備未知, 運行gavrasm -T以獲得支持的設備列表!',
    '054: Too many parameters, expecting device name only! 參數太多,只能期望設備名!',
    '055: Symbol or register %1 already defined! 已定義符號或寄存器%1!',
    '056: Cannot set undefined symbol (%1)! 無法設置未定義的符號 (%1)!',
    '057: Macro (%1) already defined! Macro (%1) 已經定義!',
    '058: Too many parameters, expected a macro name only! 參數太多, 只有一個巨集名!',
    '059: Closing macro without one open or macro empty! 關閉巨集沒有打開或巨集空!',
    '060: .IF condition missing! .IF條件丟失!',
    '061: Undefined constant/variable in condition, must be set before! 未定義的常量/變量在條件下, 必須先設置!',
    '062: Error in condition! 條件錯誤!',
    '063: Too many parameters, expected one logical condition! 參數太多, 預期一個邏輯條件!',
    '064: .ENDIF without .IF! .ENDIF沒有.IF!',
    '065: .ELSE/ELIF without .IF! .ELSE / ELIF沒有.IF!',
    '066: Illegal directive within %1-segment or macro! %1 -segment 或 macro 中的非法指令',
    '067: Unknown directive! 未明編譯指令!',
    '068: No macro open to add lines! 沒有巨集打開添加行!',
    '069: Error in macro parameters! 巨集參數錯誤!',
    '070: Unknown instruction or macro! 未知的指令或巨集!',
    '071: String exceeds line! 字串跨行!',
    '072: Unexpected end of line in literal constant! 文字常數中出現意外的行尾!',
    '073: Literal constant '''''''' expected, end of line found! 預期字面常數 """"", 但出現 end of line (CR/LF)!',
    '074: Literal constant '''''''' expected, but char <> '' found! 預期字面常數 """"", 但出現<>!',
    '075: Missing second '' in literal constant! 在文字常數中缺少第二個"',
    '076: '':'' missing behind label or instruction starting in column 1! ":" 從第1列開始丟失標籤或指令',
    '077: Double label in line! 雙標籤在該行!',
    '078: Missing closing bracket! 缺少關閉括號!',
    '079: Line not starting with a label, a directive or a separator! 行不是從標籤, 指令或分隔符開始!',
    '080: Illegal macro line parameter (should be @0..@9)! 非法巨集線參數(應為@0 .. @9)!',
    '081: Code segment (%1 words) exceeds limit (%2 words)! 代碼段 (%1個字) 超出限制 (%2個字) !',
    '082: Eeprom segment (%1 bytes) exceeds limit (%2 bytes)! Eeprom段 (%1字節) 超出限制 (%2字節) !',
    '083: Missing macro name! 缺少巨集名!',
    '084: Undefined parameter in EXIT-directive! EXIT-directive!中的未定義參數',
    '085: Error in logical expression of the EXIT-directive! EXIT-directive!的邏輯表達式出錯!',
    '086: Break condition is true, assembling stopped! 休息條件是真的, 集會停止!',
    '087: Illegal literal constant (%1)! 非法文字常數 (%1) !',
    '088: Illegal string constant (%1)! 非法字符串常量 (%1)!',
    '089: String (%1) not starting and ending with "!" String (%1) 不以“!”開頭和結尾, ',
    '090: Unexpected parameter or trash on end of line! 行末尾的意外參數或垃圾桶!',
    '091: Missing or unknown parameter(s)! 丟失或未知參數!',
    '092: Unknown device name (%1)! 設備名稱未知 (%1)!',
    '093: Definition of basic symbols failed! 基本符號的定義失敗!',
    '094: Definition of Int-Vector-Addresses failed! 中斷向量地址的定義失敗!',
    '095: Definition of symbols failed! 符號的定義失敗!',
    '096: Definition of register names failed! 寄存器名稱的定義失敗!',
    '097: Unrecognized include file, use .DEVICE instead! 無法識別的包含文件, 使用.DEVICE代替!',
    '098: Device doesn''t support Auto-Inc/Dec statement! 設備不支持Auto-Inc / Dec語句!',
    '099: IF statement without ENDIF! 沒有ENDIF!的IF語句',
    '100: Multiple DEVICE definition! 過多DEVICE定義',
    '101: Division by Zero 除零',
    '102: %1 instruction requires Z as parameter, not %2! %1 指令需要 Z 參數, 並非 %2!'
	);

Procedure ExchPars(sp,se:WideString;Var s:WideString);
Var p:Byte;
Begin
p:=Pos(sp,s);
If p>0 Then
  Begin
  Delete(s,p,Length(sp));
  Insert(se,s,p);
  End;
End;

Function GetMsg(c:Char;nem:Byte;s1,s2:WideString):WideString;
Begin
Case c Of
  'M':GetMsg:=as[nem];
  'W':GetMsg:=asw[nem];
  'E':GetMsg:=ase[nem];
  End;
ExchPars('%1',s1,GetMsg);
ExchPars('%2',s2,GetMsg);
End;

Function GetMsgW(nem:Byte;s1,s2:WideString):WideString;
Begin
GetMsgW:=GetMsg('W',nem,s1,s2);
End;

Function GetMsgE(nem:Byte;s1,s2:WideString):WideString;
Begin
If nem=0 Then
  GetMsgE:='Forced error: '+cl.sString Else
  GetMsgE:=GetMsg('E',nem,s1,s2);
End;

Function GetMsgM(nem:Byte):WideString;
Begin
GetMsgM:=as[nem];
End;

Begin
nMaxErr:=nase;
End.