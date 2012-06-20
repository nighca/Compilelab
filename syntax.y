%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "helper.h"

int yylex(void);
void yyerror(char *);
void debuginfo(char *, int *, char *);
void print_info(char *);
void push(char *);
char* pop();
void reduction(int, char *);
void print_stack();

char state[100][100]={'\0'};
int state_num=0;

char *readed[100]={NULL};
char *cur=NULL;
char *stack[100]={NULL};
int pushed = 0;
int top=0;
int num=0;


%}

%token _ID _TYPE POS_INT _REAL _PROGRAM _BEGIN _END _CONST _TRUE _FALSE _ARRAY _IF _THEN _WHILE _ELSE _FOR _TO _DO _REPEAT _UNTIL _READ _WRITE _FUNC COLON ASSIGN C_ASSIGN SEMI COMMA PL MI MU DI AND OR NOT LT LE EQ LG GE GT
%left PL MI AND OR
%left MU DI
%right NOT
%%
 
program:
_PROGRAM _ID SEMI expl _BEGIN sens _END              { reduction(7,"program:_PROGRAM _ID SEMI expl _BEGIN sens _END"); }
|_PROGRAM _ID SEMI _BEGIN sens _END                  { reduction(7,"program:_PROGRAM _ID SEMI _BEGIN sens _END"); }
;

expl: 
_CONST def SEMI                                      {reduction(3,"expl:_CONST def SEMI");}
| var_expl_sens                                      {reduction(1,"expl:var_expl_sens");}
| func_expl                                          {reduction(1,"expl:func_expl");}
| expl expl                                          {reduction(2,"expl:expl expl");}
;

def:
_ID C_ASSIGN const                                   {reduction(3,"def:_ID C_ASSIGN const ");}
| _ID C_ASSIGN const COMMA def                       {reduction(5,"def:_ID C_ASSIGN const COMMA def ");}
;

var_expl_sens:
var_expl_sen                                         {reduction(1,"var_expl_sens:var_expl_sen");}
| var_expl_sen var_expl_sens                         {reduction(2,"var_expl_sens:var_expl_sen var_expl_sens");}
;

var_expl_sen:
var_expl SEMI                                        {reduction(2,"var_expl_sen:var_expl SEMI  ");}
;

var_expl:
_TYPE COLON ids                                      {reduction(3,"var_expl:_TYPE COLON ids ");}
| _TYPE COLON array_expl                             {reduction(3,"var_expl:_TYPE COLON array_expl");}
;

func_expl:
_FUNC _ID _BEGIN sens _END                           {reduction(5,"func_expl:_FUNC _ID _BEGIN sens _END");}
;

array_expl:
_ARRAY _ID '[' di_expl ']'                           {reduction(5,"array_expl:_ARRAY _ID '[' di_expl ']'");}
| _ARRAY _ID '[' di_expl ']' COMMA array_expl        {reduction(7,"array_expl:_ARRAY _ID '[' di_expl ']' COMMA array_expl");}
;

sens:
sen                                                  {reduction(1,"sens:sen");}
| sen sens                                           {reduction(2,"sens:sen sens");}
;

sen:
_sen SEMI                                            {reduction(2,"sen:_sen SEMI");}
| _IF expr _THEN sen                                 {reduction(4,"sen:_IF expr _THEN sen");}
| _IF expr _THEN sen _ELSE sen                       {reduction(6,"sen:_IF expr _THEN sen _ELSE sen");}
| _WHILE expr _DO sen	                             {reduction(4,"sen:_WHILE expr _DO sen");}
| _FOR var ASSIGN expr _TO expr _DO sen	             {reduction(8,"sen:_FOR var ASSIGN expr _TO expr _DO sen");}
| _BEGIN sens _END	                                 {reduction(3,"sen:_BEGIN sens _END");}
;

_sen:
var ASSIGN expr                                      {reduction(3,"_sen:var ASSIGN expr");}
| _REPEAT sens _UNTIL expr	                         {reduction(4,"_sen:_REPEAT sens _UNTIL expr");}
| _READ ids	                                         {reduction(2,"_sen:_READ ids");}
| _WRITE exprs	                                     {reduction(2,"_sen:_WRITE exprs");}
| func                                               {reduction(1,"_sen:func");}
;

func:
_ID                                                  {reduction(1,"func:_ID");}
;

exprs:
expr                                                 {reduction(1,"exprs:expr");}
| expr COMMA exprs                                   {reduction(3,"exprs:expr COMMA exprs");}
;

expr:
const                                                {reduction(1,"expr:const");}
| var                                                {reduction(1,"expr:var");}
| expr op expr                                       {reduction(3,"expr:expr op expr");}
| '(' expr ')'                                       {reduction(3,"expr:'(' expr ')'");}
;

di_expl:
POS_INT                                              {reduction(1,"di_expl:POS_INT");}
| POS_INT COMMA di_expl                              {reduction(3,"di_expl:POS_INT COMMA di_expl");}
;

var:
_ID                                                  {reduction(1,"var:_ID");}
| array_var                                          {reduction(1,"var:array_expl");}
;

array_var:
_ID '[' expr ']'                                     {reduction(4,"array_var:_ID [ expr ]");}
;

ids:
_ID                                                  {reduction(1,"ids:_ID");}
| _ID COMMA ids                                      {reduction(3,"ids:_ID COMMA ids");}
;

const:
int                                                  {reduction(1,"const:int");}
| _REAL                                              {reduction(1,"const:_REAL");}
| _TRUE                                              {reduction(1,"const:_TRUE");}
| _FALSE                                             {reduction(1,"const:_FALSE");}
;

op:
m_op                                                 {reduction(1,"op:m_op");}
| l_op                                               {reduction(1,"op:l_op");}
| r_op                                               {reduction(1,"op:r_op");}
;

m_op:
PL                                                   {reduction(1,"m_op:PL");}
| MI                                                 {reduction(1,"m_op:MI");}
| MU                                                 {reduction(1,"m_op:MU");}
| DI                                                 {reduction(1,"m_op:DI");}
;

l_op:
AND                                                  {reduction(1,"l_op:AND");}
| OR                                                 {reduction(1,"l_op:OR");}
| NOT                                                {reduction(1,"l_op:NOT");}
;

r_op:
LT                                                   {reduction(1,"r_op:LT");}
| LE                                                 {reduction(1,"r_op:LE");}
| EQ                                                 {reduction(1,"r_op:EQ");}
| LG                                                 {reduction(1,"r_op:LG");}
| GE                                                 {reduction(1,"r_op:GE");}
| GT                                                 {reduction(1,"r_op:GT");}
;

int:
POS_INT                                              {reduction(1,"int:POS_INT");}
| '0'                                                {reduction(1,"int:0");}
| MI POS_INT                                         {reduction(2,"int:MI POS_INT");}
;

%%

void push(char *s) {
    stack[top++]=s;
    pushed = 1;
}

char* pop() {
    top--;
    if (top < 0) {
        printf("done\n!");
        return NULL;
    }
    return stack[top];
}

void reduction(int arg_num, char *s) {
    printf("%d", num);

    //print_stack();
    printf("----> reduction %s\n", s);

    int i;
    for(i=0; i<arg_num; i++) 
        pop();

    char *new_p = state[state_num];
    state_num++;

    int j=0;
    while(s[j]!=':'){
        new_p[j]=s[j];j++;
    }
    new_p[j]='\0';

    push(new_p);
}


/*
void print_stack(){
    int i=0;
    for(i=0;i<top;i++){
        printf("%d: %s\n",i,stack[i]);
    }
}
*/
void yyerror(char *s) {
    printf("%s\n", s);
}


int main(void) {
    yyparse();
    return 0;
}
