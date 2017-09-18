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
 
  xiaolaba, 2017-sep-18, Simplified Chinese Language interface (CHS or CN)
  Tools: ConvertZ, used to convert BIG5 encoded string to CN encoded
  
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
    {1} 'Unknown option on command line: 命令行上的未知选项: ',
    {2} 'Source file not found: 源文件未找到: ',
    {3} 'Error, 错误 ',
    {4} 'File: 档案:  ',
    {5} 'Line: 行号:  ',
    {6} 'Source line: 源码行:  ',
    {7} 'Warning, 警告 ',
    {8} 'List of symbols: 符号列表: ',
    {9} 'Type nDef nUsed Decimalval  Hexvalue Name 键入 nDef nUsed Decimalval Hexvalue Name ',
    {10} 'No symbols defined. 没有符号定义 ',
    {11} 'List of macros: 巨集列表: ',
    {12} 'nLines nUsed nParams NamenLines nUsed nParams Name ',
    {13} '   No macros, 没有巨集", ',
    {14} 'Including file, 包括文件 ',
    {15} 'Continuing file, 接续档案 ',
    {16} ' lines done, 读取完成 ',

    {17} 'Source file: 源码       : ',
    {18} 'Hex file   : 烧录档     : ',
    {19} 'Eeprom file: EEPROM档   : ',
    {20} 'Compiled   : 开始编译   : ',
    {21} 'Pass       : 通过       : ',

    {22} 'Compiling 编译中 ',
    {23} ' words code, 代码字节, ',
    {24} ' words constants, total= 常数字节, 总数 = ',
    {25} 'No warnings! 没有警告! ',
    {26} 'One warning! 一个警告! ',
    {27} ' warnings!警告! ',

    {28} 'Compilation completed, no errors. 编译完成无误. ',
    {29} 'Program             : 程序       : ',
    {30} 'Constants           : 常数       : ',
    {31} 'Total program memory: 总程序长度 : ',
    {32} 'Eeprom space        : EEPROM用量 : ',
    {33} 'Data segment        : 数据       : ',
    {34} 'Compilation endet 结束编译 ',

    {35} 'Compilation aborted, 退出编译 ',
    {36} 'one error! 一个错误! ',
    {37} ' errors! 错误 ! ',
    {38} ' Bye, bye ... 再见... ',
    {39} 'not even, 非偶数 {偶数指令寄存器! } ',
    {40} ' \\ Instruction has no parameters!, 指令没有参数! ',
    {41} 'register in the range from R0 to R31, 寄存器 R0 - R31 ',
    {42} 'bit value in the range from 0 to 7, 位元值 0-7 ',
    {43} 'relative jump address (label) in the range from -64 to +63, 相对跳转地址（标签）的范围从-64到+63 ',
    {44} 'absolute jump address (label), 16/22-bit-address, 绝对跳转地址（标签）,16/22位地址 ',
    {45} 'none or register and Z or register and Z+, 无或寄存器, Z 或 Z+ ',
    {46} 'relative jump address (label) in the range +/- 2k, 相对跳转地址（标签）在+/- 2k范围内, ',
    {47} 'register in the range from R16 to R31, 寄存器 R16 - R31 ',
    {48} 'double register R24, R26, R28 or R30, 双寄存器 R24,R26,R28 或 R30 ',
    {49} 'lower port value between 0 and 31, 端口值 0 - 31 ',
    {50} 'register in the range from R16 to R23, 寄存器 R16 - R23 ',
    {51} 'even register (R0, R2 ... R30), 偶数寄存器（R0, R2 ... R30) ',
    {52} 'port value in the range from 0 to 63, 端口值 0 - 63 ',
    {53} 'X/Y/Z or X+/Y+/Z+ or -X/-Y/-Z ',
    {54} 'Y+distance or Z+distance, range 0..63, Y+偏移量 或 Z+偏移量, 范围 0..63 ',
    {55} '16-bit SRAM address, 16位SRAM地址 ',
    {56} 'Constant in the range 0..63, 常量范围 0..63 ',
    {57} 'Constant in the range 0..255, 常量范围 0..255 ',
    {58} 'parameter, 参数 ',
    {59} 'Internal compiler error! Please report to gavrasm@avr-asm-tutorial.net! 编译器错误! 请回报给作者 ',
    {60} 'See the list of directives with gavrasm -d, 使用 gavrasm -d, 查看可用的指令列表  ',
    {61} 'List of supported directives, 可用的指令列表" ',
    {62} '.BYTE x   : reserves x bytes in the data segment (see .DSEG), 在数据段中保留x个字节（请参阅.DSEG） ',
    {63} '.CSEG     : compiles into the code segment, 编译成代码段 ',
    {64} '.DB x,y,z : inserts Bytes, chars or strings (.CSEG, ESEG), 插入位元组, 字符, 字串（.CSEG,ESEG） ',
    {65} '.DEF x=y  : symbol name x is attached to register y, 符号名称x 附加到寄存器y ',
    {66} '.DEVICE x : check the code for the AVR type x, 检查 AVR 类型 x 的代码 ',
    {67} '.DSEG     : data segment, only labels and .BYTE directives, 数据段,只有标签和 .BYTE 指令 ',
    {68} '.DW x,y,z : insert words (.CSEG, .ESEG), 插入字节（.CSEG,.ESEG） ',
    {69} '.ELIF x   : .ELSE with condition x, ',
    {70} '.ELSE     : alternative code, if .IF-condition was false, 如果.IF条件为false 替代的源码 ',
    {71} '.ENDIF    : closes .IF resp. .ELSE or .ELIF, 关闭.IF .ELSE或.ELIF ',
    {72} '.EQU x=y  : the symbol x is set to the constant value y, 将符号x设置为常数值y ',
    {73} '.ERROR x  : forces an error with the message x, 强制使用消息x ',
    {74} '.ESEG     : compiles to the Eeprom segment, 编译成Eeprom段, ',
    {75} '.EXIT [x] : closes source file, x is a logical expression, 关闭源文件,x是逻辑表达式 ',
    {76} '.IF x     : compiles the code, if x is true, 编译代码,如果x为真 ',
    {77} '.IFDEF x  : compiles the code if variable x is defined, 编译代码如果变量x被定义 ',
    {78} '.IFDEVICE type: compiles the code if the type is correct, 如果类型正确, 编译代码 ',
    {79} '.IFNDEF x : compiles the code if variable x is undefined, 如果变量x未定义,则编译代码 ',
    {80} '.INCLUDE x: inserts the file "path/name" into the source, 加入文件 ',
    {81} '.MESSAGE x: displays the message x, 显示讯息x ',
    {82} '.LIST     : switches list output on, 开启列表功能 ',
    {83} '.LISTMAC  : switches list output for macros on, 列印巨集 ',
    {84} '.MACRO x  : define macro named x, 定义巨集名为x ',
    {85} '.ENDMACRO : closes the current macro definition (see .ENDM), 关闭当前的巨集定义（参见.ENDM） ',
    {86} '.ENDM     : the same as .ENDMACRO, 等同 .ENDMACRO ',
    {87} '.NOLIST   : switches list output off, 关闭列表功能 ',
    {88} '.ORG x    : sets the CSEG-/ESEG-/DSEG-counter to value x, 将 CSEG-/ESEG-/DSEG- 赋值为 x ',
    {89} '.SET x=y  : sets the variable symbol x to the value y, 将变量符号 x 赋值为 y ',
    {90} '.SETGLOBAL x,y,z: globalize the local symbols x, y and z 将本地符号 x,y,z 设为全局变数, ',
    {91} '.UNDEF x  : undefines the symbol x, 未定义符号 x ',
    {92} 'Constant in the range 0..15, 常量 0..15 ',
    {93} 'Pointer Z 指针Z '
	);

  nasw=11;
  asw:Array[1..nasw] Of WideString=(
    '001: %1 symbol(s) defined, but not used! 符号定义但未使用!',
    '002: More than one SET on variables(s)! 变量有一个以上的SET!',
    '003: No legal parameters found! 无合法参数!',
    '004: Number of bytes on line is odd, added 00 to fit program memory!字节为奇数,添加00配合存储器边界!',
    '005: Data segment (%1 bytes) exceeds device limit (%2 bytes)! 数据段 (%1 bytes) 超过设备限制 (%2 bytes)!',
    '006: No device defined, no syntax checking! 没有设备定义,没有语法检查!',
    '007: Wrap-around! 四舍五入!',
    '008: More than one SET on global variable (%1)! 全局变量 (%1) 上有多个 SET!',
    '009: Include defs not necessary, using internal values! 不必要的 defs, 使用内部值!',
    '010: Instruction set unclear, no documentation! 指令集不清楚, 无文件!',
    '011: C-style instructions in file, lines ignored! 文件中的C格式的指令,忽略该行!'
	);

  nase=102;
  ase:Array[1..nase] Of WideString=(
    '001: Illegal character (%1) in symbol name! 符号名称中的非法字符 (%1)!',
    '002: Symbol name (%1) is a mnemonic, illegal! 符号名称 (%1) 是一个助记符, 非法!',
    '003: Symbol name (%1) not starting with a letter! 符号名 (%1) 不以字母开头!',
    '004: Illegal character in binary value (%1)! 二进制值 (%1) 中的非法字符!',
    '005: Illegal character in hex value (%1)! 十六进制值中的非法字符 (%1)!',
    '006: Illegal character in decimal value (%1)! 十进制值中的非法字符 (%1)!',
    '007: Undefined constant, variable, label or device (%1)! 未定义的常量, 变量, 标签或设备 (%1)!',
    '008: Unexpected = in expression, use == instead! 算式含有 = , 使用 == !',
    '009: Overflow of expression (%1) during shift-left(%2)! 左移 (%2) 运算溢出 (%1) !',
    '010: Overflow during multiplication (%1) by (%2)! (%1) 乘以 (%2) 乘法溢出 !',
    '011: Overflow during addition (%1) and (%2)! (%1) 和 (%2) 加法溢出!',
    '012: Underflow during subtraction (%2) from (%1)! (%2) - (%1) 无借位 !',
    '013: Unknown function %1! 未知功能%1!',
    '014: Illegal character (%1) in expression! 表达中的非法字符 (%1)!',
    '015: Missing opening bracket in expression! 表达式中缺少开头的括号!',
    '016: Missing closing bracket in expression! 表达式中没有关闭括号!',
    '017: Register value (%1) out of range (%2)! 寄存器值 (%1) 超出范围 (%2) !',
    '018: Register value undefined! 寄存器值未定!',
    '019: Register value missing! 寄存器没有赋值!',
    '020: Port value not valid! 端口值无效!',
    '021: Port value (%1) out of range (%2)! 端口值 (%1) 超出范围 (%2) !',
    '022: Bit value (%1) out of range (0..7)! 位值 (%1) 超出范围 (0..7) !',
    '023: Label (%1) invalid or out of range (%2)! 标签 (%1) 无效或超出范围 (%2) !',
    '024: Constant (%1) out of range (%2)! 常数 (%1) 超出范围 (%2) !',
    '025: Expression of constant (%1) unreadable! 表达式 (%1) 不可读!',
    '026: Constant invalid! 常数无效!',
    '027: %1 instruction can only use -XYZ+, not %2 %1指令只能使用-XYZ+ 而不是%2',
    '028: Missing X/Y/Z in %1 instruction! 在%1指令中缺少X / Y / Z!',
    '029: %1 instruction requires Y or Z as parameter, not %2! %1指令需要Y或Z作为参数, 而不是%2!',
    '030: Displacement (%1) out of range (%2)! 位移 (%1) 超出范围 (%2) !',
    '031: Parameter X+d/Y+d missing! 未提供参数X + d / Y + d!',
    '032: ''+'' expected, but ''%1'' found! 预期 "+", 但出现 "%1" !',
    '033: Register and Z/Z+ expected, but %1 found! 预期寄存器 Z / Z+, 但出现 %1 !',
    '034: Register missing! 无寄存器!',
    '035: Illegal instruction (%1) for device type (%2)! 设备类型 (%2) 的非法指令 (%1) !',
    '036: Include file (%1) not found! 包含文件 (%1) 未找到!',
    '037: Name of Include file missing! 无包含文件的名称!',
    '038: Error in parameter %1 (%2) in directive! 编译指示参数%1 (%2) 出错',
    '039: Missing "=" in directive! 编译指示缺少 "="',
    '040: Name (%1) already in use for a %2! %2 的名称 (%1) 已被使用',
    '041: Failed resolving right side of equation in EQU/SET/DEF! 在EQU / SET / DEF 中无法解析方程的右侧',
    '042: Missing number of bytes to reserve! 缺少预留的字节数!',
    '043: Invalid BYTE constant! 无效的BYTE常数!',
    '044: Too many parameters, expected number of bytes only! 太多的参数, 只有预期的字节数!',
    '045: Missing ORG address, no parameters! 缺少ORG的地址, 没有参数!',
    '046: Origin address (%1) points backwards in %2! 原始地址 (%1) 在%2 中向后点',
    '047: Undefined ORG constant! 未定义ORG常数!',
    '048: Too many parameters on ORG line, only address! ORG线上的参数太多, 只需地址!',
    '049: No literals allowed in DW directive! Use DB instead! DW指令中不允许使用字面值!使用DB代替!',
    '050: No parameters found, expected words! 找不到参数, 需要双字节WORD!',
    '051: Expected device name, no name found! 找不到MCU型号!',
    '052: Device already defined! MCU型号已经定义!',
    '053: Unknown device, run gavrasm -T for a list of supported devices! MCU型号未知, 运行 gavrasm -T 以获得支持的型号列表!',
    '054: Too many parameters, expecting device name only! 参数太多, 只要MCU型号!',
    '055: Symbol or register %1 already defined! 已定义符号或寄存器%1!',
    '056: Cannot set undefined symbol (%1)! 无法设置未定义的符号 (%1)!',
    '057: Macro (%1) already defined! Macro (%1) 已经定义!',
    '058: Too many parameters, expected a macro name only! 参数太多, 只要一个巨集名!',
    '059: Closing macro without one open or macro empty! 关闭巨集没有打开或巨集空!',
    '060: .IF condition missing! 缺少.IF条件指示!',
    '061: Undefined constant/variable in condition, must be set before! 未定义的常量/变量在条件下, 必须先设置!',
    '062: Error in condition! 条件错误!',
    '063: Too many parameters, expected one logical condition! 参数太多, 预期一个逻辑条件!',
    '064: .ENDIF without .IF! .ENDIF没有.IF!',
    '065: .ELSE/ELIF without .IF! .ELSE / ELIF没有.IF!',
    '066: Illegal directive within %1-segment or macro! %1 -segment 或 macro 中的非法指令',
    '067: Unknown directive! 未明编译指令!',
    '068: No macro open to add lines! 没有巨集打开添加行!',
    '069: Error in macro parameters! 巨集参数错误!',
    '070: Unknown instruction or macro! 未知的指令或巨集!',
    '071: String exceeds line! 字串过长!',
    '072: Unexpected end of line in literal constant! 文字常数中出现意外的行尾!',
    '073: Literal constant '''''''' expected, end of line found! 预期字面常数 """"", 但出现 end of line (CR/LF)!',
    '074: Literal constant '''''''' expected, but char <> '' found! 预期字面常数 """"", 但出现<>!',
    '075: Missing second '' in literal constant! 在文字常数中缺少第二个"',
    '076: '':'' missing behind label or instruction starting in column 1! ":" 从第1列开始丢失标签或指令',
    '077: Double label in line! 双标签在该行!',
    '078: Missing closing bracket! 缺少关闭括号!',
    '079: Line not starting with a label, a directive or a separator! 行不是从标签, 指令或分隔符开始!',
    '080: Illegal macro line parameter (should be @0..@9)! 非法巨集线参数 (应为@0 .. @9)!',
    '081: Code segment (%1 words) exceeds limit (%2 words)! 代码段 (%1个字) 超出限制 (%2个字) !',
    '082: Eeprom segment (%1 bytes) exceeds limit (%2 bytes)! Eeprom段 (%1字节) 超出限制 (%2字节) !',
    '083: Missing macro name! 缺少巨集名!',
    '084: Undefined parameter in EXIT-directive! EXIT-directive! 中的未定义参数',
    '085: Error in logical expression of the EXIT-directive! 逻辑表达式 EXIT-directive 出错!',
    '086: Break condition is true, assembling stopped! 停止条件出现, 编译停止!',
    '087: Illegal literal constant (%1)! 非法文字常数 (%1) !',
    '088: Illegal string constant (%1)! 非法字符串常量 (%1)!',
    '089: String (%1) not starting and ending with "!" 字串开始结尾没有“!”',
    '090: Unexpected parameter or trash on end of line! 行末尾的意外参数或垃圾字元!',
    '091: Missing or unknown parameter(s)! 丢失或未知参数!',
    '092: Unknown device name (%1)! MCU型号未知 (%1)!',
    '093: Definition of basic symbols failed! 基本符号的定义失败!',
    '094: Definition of Int-Vector-Addresses failed! 中断向量地址的定义失败!',
    '095: Definition of symbols failed! 符号的定义失败!',
    '096: Definition of register names failed! 寄存器名称的定义失败!',
    '097: Unrecognized include file, use .DEVICE instead! 无法识别的包含文件, 使用 .DEVICE 代替!',
    '098: Device doesn''t support Auto-Inc/Dec statement! MCU型号不支持 Auto-Inc/Dec 指令!',
    '099: IF statement without ENDIF! 逻辑判断 IF 语句没有对应的 ENDIF!',
    '100: Multiple DEVICE definition! 多重 DEVICE 定义',
    '101: Division by Zero 除零',
    '102: %1 instruction requires Z as parameter, not %2! %1 指令需要 Z 参数, 并非 %2!'
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