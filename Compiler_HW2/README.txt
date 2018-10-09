command:
flex project2_scanner.l
yacc -d project2_parser.y
cc node.c y.tab.c -ly
./a.out (testfile)

description:
在linux(ubuntu)環境下執行，並將3個測資檔以./a.out testfile>test.txt 的方式將結果印出。

test00.txt 為執行test00-runtime-range-check.p 的示範結果
test01.txt 為執行test01-global-var 的示範結果
test02.txt 為執行test02-uninitialized-var.o 的示範結果



