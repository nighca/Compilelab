%{

#include <stdlib.h>
#include <stdio.h>
#include "syntax.tab.h"
#include "helper.h"

void yyerror(char *);
void Moveinto(char *);
void push();
void pop();

extern char *readed[100];
extern char *cur;
extern char *stack[2][20];
extern int num;
extern int pushed;

extern int WIDTH[4];

%}

%%

PROGRAM                     {Moveinto(yytext);return _PROGRAM;}
BEGIN                       {Moveinto(yytext);return _BEGIN;}
END                         {Moveinto(yytext);return _END;}
CONST                       {Moveinto(yytext);return _CONST;}
TRUE                        {yylval.name = *yytext; yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _TRUE;}
FALSE                       {yylval.name = *yytext; yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _FALSE;}
ARRAY                       {Moveinto(yytext);return _ARRAY;}
IF                          {Moveinto(yytext);return _IF;}
THEN                        {Moveinto(yytext);return _THEN;}
WHILE                       {Moveinto(yytext);return _WHILE;}
ELSE                        {Moveinto(yytext);return _ELSE;}
FOR                         {Moveinto(yytext);return _FOR;}
TO                          {Moveinto(yytext);return _TO;}
DO                          {Moveinto(yytext);return _DO;}
REPEAT                      {Moveinto(yytext);return _REPEAT;}
UNTIL                       {Moveinto(yytext);return _UNTIL;}
READ                        {Moveinto(yytext);return _READ;}
WRITE                       {Moveinto(yytext);return _WRITE;}
FUNC                        {Moveinto(yytext);return _FUNC;}

program                     {Moveinto(yytext);return _PROGRAM;}
begin                       {Moveinto(yytext);return _BEGIN;}
end                         {Moveinto(yytext);return _END;}
const                       {Moveinto(yytext);return _CONST;}
array                       {Moveinto(yytext);return _ARRAY;}
if                          {Moveinto(yytext);return _IF;}
then                        {Moveinto(yytext);return _THEN;}
while                       {Moveinto(yytext);return _WHILE;}
else                        {Moveinto(yytext);return _ELSE;}
for                         {Moveinto(yytext);return _FOR;}
to                          {Moveinto(yytext);return _TO;}
do                          {Moveinto(yytext);return _DO;}
repeat                      {Moveinto(yytext);return _REPEAT;}
until                       {Moveinto(yytext);return _UNTIL;}
read                        {Moveinto(yytext);return _READ;}
write                       {Moveinto(yytext);return _WRITE;}
func                        {Moveinto(yytext);return _FUNC;}

\:                           {Moveinto(yytext);return COLON;}
\:\=                          {Moveinto(yytext);return ASSIGN;}
\=                          {Moveinto(yytext);return C_ASSIGN;}
\;                           {Moveinto(yytext);return SEMI;}
\,                           {Moveinto(yytext);return COMMA;}

[+]                           {Moveinto(yytext);return PL;}
[-]                           {Moveinto(yytext);return MI;}
[*]                           {Moveinto(yytext);return MU;}
[/]                           {Moveinto(yytext);return DI;}

AND                         {Moveinto(yytext);return AND;}
OR                          {Moveinto(yytext);return OR;}
NOT                         {Moveinto(yytext);return NOT;}

[<]                           {Moveinto(yytext);return LT;}
\<\=                          {Moveinto(yytext);return LE;}
[=]{2}                           {Moveinto(yytext);return EQ;}
\<\>                          {Moveinto(yytext);return LG;}
\>\=                          {Moveinto(yytext);return GE;}
[>]                           {Moveinto(yytext);return GT;}

INTEGER                     {yylval.name = *yytext;yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return _TYPE;}
REAL                        {yylval.name = *yytext;yylval.type = __REAL__;yylval.width=WIDTH[__REAL__];Moveinto(yytext);return _TYPE;}
BOOLEAN                     {yylval.name = *yytext;yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _TYPE;}
[a-zA-Z][a-zA-Z0-9]*        {yylval.name = *yytext; Moveinto(yytext);return _ID;}
[0-9]*\.[0-9]+              {yylval.name = *yytext;yylval.type = __REAL__;yylval.width=WIDTH[__REAL__];Moveinto(yytext);return _REAL;}
[1-9][0-9]*                 {yylval.name = *yytext;yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return POS_INT;}
0                           {yylval.name = *yytext;yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return *yytext;}
[()\[\]]                        {yylval = *yytext;Moveinto(yytext);return *yytext;}


[ \t\n]                    {				}
.                           yyerror("无效字符");

%%

void Moveinto(char * buff) {
    printf("%d", num);
    printf("----> Move into %s\n", cur);

    if (cur!=NULL)
        push(cur);
    cur = strdup(buff);
    pushed = 0;

    readed[num]=buff;

    num++;
}

int yywrap(void) {
    return 1;
}
