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

char *cur_name = NULL;
int cur_type = NIL;
int cur_width = NIL;

int WIDTH[4] = {-1,4,8,1};

int new_dest_to;
int new_dest_to2;
int while_begin_from;


%}

%token _ID _TYPE POS_INT _REAL _PROGRAM _BEGIN _END _CONST _TRUE _FALSE _ARRAY _IF _THEN _WHILE _ELSE _FOR _TO _DO _REPEAT _UNTIL _READ _WRITE _FUNC COLON ASSIGN C_ASSIGN SEMI COMMA PL MI MU DI AND OR NOT LT LE EQ LG GE GT
%left PL MI AND OR
%left MU DI
%right NOT
%%
 
program:
_PROGRAM _ID SEMI expl _BEGIN sens _END             {reduction(7,"program:_PROGRAM _ID SEMI expl _BEGIN sens _END"); }
|_PROGRAM _ID SEMI _BEGIN sens _END                 {reduction(7,"program:_PROGRAM _ID SEMI _BEGIN sens _END"); }
;

expl: 
_CONST def SEMI                                     {reduction(3,"expl:_CONST def SEMI");}
| var_expl_sens                                     {reduction(1,"expl:var_expl_sens");}
| func_expl                                         {reduction(1,"expl:func_expl");}
| expl expl                                         {reduction(2,"expl:expl expl");}
;

def:
_ID C_ASSIGN const                                  {
                                                    cur_type=$3.type;cur_width=$3.width;cur_name=$1.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    gen("=",$3.name,NULL,$1.name);
                                                    reduction(3,"def:_ID C_ASSIGN const ");
                                                    }
| _ID C_ASSIGN const COMMA def                      {
                                                    cur_type=$3.type;cur_width=$3.width;cur_name=$1.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    gen("=",$3.name,NULL,$1.name);
                                                    reduction(5,"def:_ID C_ASSIGN const COMMA def ");
                                                    }
;

var_expl_sens:
var_expl_sen                                        {reduction(1,"var_expl_sens:var_expl_sen");}
| var_expl_sen var_expl_sens                        {reduction(2,"var_expl_sens:var_expl_sen var_expl_sens");}
;

var_expl_sen:
var_expl SEMI                                       {reduction(2,"var_expl_sen:var_expl SEMI  ");}
;

var_expl:
_TYPE COLON _ID                                     {
                                                    $$.type=$1.type;$$.width=$1.width;
                                                    cur_type=$1.type;cur_width=$1.width;cur_name=$3.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    reduction(3,"var_expl:_TYPE COLON _ID ");
                                                    }

| _TYPE COLON array_expl                            {
                                                    $$.type=$1.type;$$.width=$1.width;
                                                    cur_type=$1.type+10;cur_width=$1.width*$3.width;cur_name=$3.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    reduction(3,"var_expl:_TYPE COLON array_expl");
                                                    }
| var_expl COMMA _ID                                {
                                                    $$.type=$1.type;$$.width=$1.width;
                                                    cur_type=$1.type;cur_width=$1.width;cur_name=$3.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    reduction(3,"var_expl:var_expl COMMA _ID");
                                                    }
| var_expl COMMA array_expl                         {
                                                    $$.type=$1.type;$$.width=$1.width;
                                                    cur_type=$1.type+10;cur_width=$1.width*$3.width;cur_name=$3.name;
                                                    enter(cur_name,cur_type,cur_width);
                                                    reduction(3,"var_expl:var_expl COMMA array_expl");
                                                    }
;

func_expl:
_FUNC _ID _BEGIN sens _END                          {reduction(5,"func_expl:_FUNC _ID _BEGIN sens _END");}
;

array_expl:
_ID '[' POS_INT ']'                                 {
                                                    $$.width=atoi($3.name);//the num of array, will multiply the width of type when added to var_expl
                                                    $$.name=$1.name;$$.type=NIL;//Unknown yet
                                                    reduction(4,"array_expl:_ID '[' POS_INT ']'");
                                                    }
;

sens:
sen                                                  {reduction(1,"sens:sen");}
| sen sens                                           {reduction(2,"sens:sen sens");}
;

sen:
_sen SEMI                                           {$$.next=$1.next;reduction(2,"sen:_sen SEMI");}
| _IF expr                                          {new_dest_to=gen("j<>", $2.name, "TRUE", NULL);} 
    _THEN sen                                       {
                                                    $$.next=$4.next;
                                                    setResult(new_dest_to, _itoa($$.next));
                                                    reduction(4,"sen:_IF expr _THEN sen");}
| _IF expr                                          {new_dest_to=gen("j<>", $2.name, "TRUE", NULL);} 
    _THEN sen                                       {new_dest_to2=gen("j",NULL,NULL,NULL);}
    _ELSE sen                                       {
                                                    $$.next=$6.next;
                                                    setResult(new_dest_to, _itoa($4.next));
                                                    setResult(new_dest_to2, _itoa($$.next));
                                                    reduction(6,"sen:_IF expr _THEN sen _ELSE sen");}
| _WHILE                                            {while_begin_from=getQuadTop();}
    expr                                            {new_dest_to=gen("j<>", $2.name, "TRUE", NULL);}
    _DO sen	                                        {
                                                    $$.next=gen("j",NULL,NULL,_itoa(while_begin_from+1))+1;
                                                    setResult(new_dest_to, _itoa($$.next));
                                                    reduction(4,"sen:_WHILE expr _DO sen");}
| _FOR var ASSIGN expr _TO expr _DO sen	            {$$.next=$8.next;reduction(8,"sen:_FOR var ASSIGN expr _TO expr _DO sen");}
| _BEGIN sens _END                                  {$$.next=$2.next;reduction(3,"sen:_BEGIN sens _END");}
;

_sen:
var ASSIGN expr                                     {$$.next=gen(":=", $3.name, NULL, $1.name)+1;
                                                    reduction(3,"_sen:var ASSIGN expr");}
| _READ id	                                        {reduction(2,"_sen:_READ id");}
| _WRITE expr	                                    {reduction(2,"_sen:_WRITE expr");}
| func                                              {reduction(1,"_sen:func");}
;

func:
_ID                                                  {reduction(1,"func:_ID");}
;

expr:
const                                               {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"expr:const");}
| var                                               {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"expr:var");}
| expr op expr                                      {
                                                    cur_type=$1.type;cur_width=$1.width;
                                                    int T=newtemp(cur_type,cur_width);
                                                    cur_name=getName(T);
                                                    $$.name=cur_name;$$.type=cur_type;$$.width=cur_width;

                                                    gen(op.name, $1.name, $3.name, cur_name);
                                                    
                                                    reduction(3,"expr:expr op expr");
                                                    }
| '(' expr ')'                                      {$$.name=$2.name;$$.type=$2.type;$$.width=$2.width;reduction(3,"expr:'(' expr ')'");}
;

var:
_ID                                                 {
                                                    cur_name=$1.name;
                                                    cur_type=getType(lookup($1.name));
                                                    cur_width=WIDTH[cur_type];
                                                    $$.type=$1.type;$$.width=$1.width;
                                                    reduction(1,"var:_ID");
                                                    }
| array_var                                         {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"var:array_var");}
;

array_var:
_ID '[' expr ']'                                    {
                                                    cur_type=getType(lookup($1.name))-10;
                                                    cur_width=WIDTH[cur_type];
                                                    int T3=newtemp(cur_type,cur_width);
                                                    cur_name=getName(T3);
                                                    $$.name=cur_name;$$.type=cur_type;$$.width=cur_width;

                                                    if($3.type!=__INTEGER__){yyerror("type of array num should be int!");}
                                                    
                                                    int T1=newtemp($3.type,$3.width);
                                                    gen("*",$3.name,"4",getName(T1));
                                                    int array_begin=getAddr(lookup($1.name));
                                                    char *temp = (char *)malloc(10 * sizeof(char));
                                                    itoa(array_begin, temp, 10);
                                                    int T2=newtemp(__INTEGER__,WIDTH[__INTEGER__]);
                                                    
                                                    gen(":=", temp, NULL, getName(T2));
                                                    gen("=[]", _strcat(_strcat(getName[T2],"["),_strcat(getName(T1),"]")),NULL,cur_name);
                                                    
                                                    reduction(4,"array_var:_ID [ expr ]");
                                                    }
;


const:
int                                                  {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"const:int");}
| _REAL                                              {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"const:_REAL");}
| _TRUE                                              {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"const:_TRUE");}
| _FALSE                                             {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"const:_FALSE");}
;

op:
m_op                                                 {$$.name=$1.name;reduction(1,"op:m_op");}
| l_op                                               {$$.name=$1.name;reduction(1,"op:l_op");}
| r_op                                               {$$.name=$1.name;reduction(1,"op:r_op");}
;

m_op:
PL                                                   {$$.name=$1.name;reduction(1,"m_op:PL");}
| MI                                                 {$$.name=$1.name;reduction(1,"m_op:MI");}
| MU                                                 {$$.name=$1.name;reduction(1,"m_op:MU");}
| DI                                                 {$$.name=$1.name;reduction(1,"m_op:DI");}
;

l_op:
AND                                                  {$$.name=$1.name;reduction(1,"l_op:AND");}
| OR                                                 {$$.name=$1.name;reduction(1,"l_op:OR");}
| NOT                                                {$$.name=$1.name;reduction(1,"l_op:NOT");}
;

r_op:
LT                                                   {$$.name=$1.name;reduction(1,"r_op:LT");}
| LE                                                 {$$.name=$1.name;reduction(1,"r_op:LE");}
| EQ                                                 {$$.name=$1.name;reduction(1,"r_op:EQ");}
| LG                                                 {$$.name=$1.name;reduction(1,"r_op:LG");}
| GE                                                 {$$.name=$1.name;reduction(1,"r_op:GE");}
| GT                                                 {$$.name=$1.name;reduction(1,"r_op:GT");}
;

int:
POS_INT                                              {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"int:POS_INT");}
| '0'                                                {$$.name=$1.name;$$.type=$1.type;$$.width=$1.width;reduction(1,"int:0");}
| MI POS_INT                                         {$$.name=_strcat("-",$1.name);$$.type=$1.type;$$.width=$1.width;reduction(2,"int:MI POS_INT");}
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
