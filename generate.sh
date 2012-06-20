rm compiler syntax.tab.c syntax.tab.h lex.yy.c
bison -d syntax.y
lex syntax.l
gcc -g -o compiler lex.yy.c syntax.tab.c
