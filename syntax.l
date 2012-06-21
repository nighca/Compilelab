%{

#include <stdlib.h>
#include <stdio.h>
#include "helper.h"
#include "syntax.tab.h"


void yyerror(char *);
void Moveinto(char *);
void push();
void pop();

extern YYSTYPE yylval;

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
TRUE                        {yylval.name = _strcat(yytext,""); yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _TRUE;}
FALSE                       {yylval.name = _strcat(yytext,""); yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _FALSE;}
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

[+]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return PL;}
[-]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return MI;}
[*]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return MU;}
[/]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return DI;}

AND                         {yylval.name = _strcat(yytext,"");Moveinto(yytext);return AND;}
OR                          {yylval.name = _strcat(yytext,"");Moveinto(yytext);return OR;}
NOT                         {yylval.name = _strcat(yytext,"");Moveinto(yytext);return NOT;}

[<]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return LT;}
\<\=                          {yylval.name = _strcat(yytext,"");Moveinto(yytext);return LE;}
[=]{2}                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return EQ;}
\<\>                          {yylval.name = _strcat(yytext,"");Moveinto(yytext);return LG;}
\>\=                          {yylval.name = _strcat(yytext,"");Moveinto(yytext);return GE;}
[>]                           {yylval.name = _strcat(yytext,"");Moveinto(yytext);return GT;}

INTEGER                     {yylval.name = _strcat(yytext,"");yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return _TYPE;}
REAL                        {yylval.name = _strcat(yytext,"");yylval.type = __REAL__;yylval.width=WIDTH[__REAL__];Moveinto(yytext);return _TYPE;}
BOOLEAN                     {yylval.name = _strcat(yytext,"");yylval.type = __BOOLEAN__;yylval.width=WIDTH[__BOOLEAN__];Moveinto(yytext);return _TYPE;}
[a-zA-Z][a-zA-Z0-9]*        {yylval.name = _strcat(yytext,"");Moveinto(yytext);return _ID;}
[0-9]*\.[0-9]+              {yylval.name = _strcat(yytext,"");yylval.type = __REAL__;yylval.width=WIDTH[__REAL__];Moveinto(yytext);return _REAL;}
[1-9][0-9]*                 {yylval.name = _strcat(yytext,"");yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return POS_INT;}
0                           {yylval.name = _strcat(yytext,"");yylval.type = __INTEGER__;yylval.width=WIDTH[__INTEGER__];Moveinto(yytext);return *yytext;}
[()\[\]]                        {yylval.name = _strcat(yytext,"");Moveinto(yytext);return *yytext;}


[ \t\n]                    {				}
.                           yyerror("无效字符");

%%

void Moveinto(char * buff) {
    //printf("%d", num);
    //printf("----> Move into %s\n", cur);

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
