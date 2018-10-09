%{
/*
 * scan.l
 *
 * lex input file for pascal scanner
 *
 * extensions: two ways to spell "external" and "->" ok for "^".
 */

#include <stdio.h>
#include <string.h>
#include "node.h"
#include "y.tab.h"


int lineCount = 1;
extern YYSTYPE yylval;

%}

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
NQUOTE [^']


%%

{A}{R}{R}{A}{Y}              {yylval.string = strdup(yytext); 
                              printf("Shift ARRAY\n"); 
                              return(ARRAY);
                             }
{D}{O}                       {yylval.string = strdup(yytext); 
                              printf("Shift DO\n"); 
                              return(DO);
                             }
{E}{L}{S}{E}                 {yylval.string = strdup(yytext); 
                              printf("Shift ELSE\n"); 
                              return(ELSE);
                             }
{E}{N}{D}                    {yylval.string = strdup(yytext); 
                              printf("Shift END\n"); 
                              return(END);
                             }
{F}{U}{N}{C}{T}{I}{O}{N}     {yylval.string = strdup(yytext); 
                              printf("Shift FUNCTION\n"); 
                              return(FUNCTION);
                             }
{I}{F}                       {yylval.string = strdup(yytext); 
                              printf("Shift IF\n"); 
                              return(IF);
                             }
{N}{O}{T}                    {yylval.string = strdup(yytext); 
                              printf("Shift NOT\n"); 
                              return(NOT);
                             }
{O}{F}                       {yylval.string = strdup(yytext); 
                              printf("Shift OF\n"); 
                              return(OF);
                             }
{B}{E}{G}{I}{N}              {yylval.string = strdup(yytext); 
                              printf("Shift BEGIN\n"); 
                              return(PBEGIN);
                             }
{P}{R}{O}{C}{E}{D}{U}{R}{E}  {yylval.string = strdup(yytext); 
                              printf("Shift PROCEDURE\n"); 
                              return(PROCEDURE);
                             }
{P}{R}{O}{G}{R}{A}{M}        {yylval.string = strdup(yytext); 
                              printf("Shift PROGRAM\n"); 
                              return(PROGRAM);
                             }
{T}{H}{E}{N}                 {yylval.string = strdup(yytext); 
                              printf("Shift THEN\n"); 
                              return(THEN);
                             }
{V}{A}{R}                    {yylval.string = strdup(yytext); 
                              printf("Shift VAR\n"); 
                              return(VAR);
                             }
{W}{H}{I}{L}{E}              {yylval.string = strdup(yytext); 
                              printf("Shift WHILE\n"); 
                              return(WHILE);
                             }
{R}{E}{A}{L}                 {yylval.string = strdup(yytext); 
                              printf("Shift REAL\n"); 
                              return(REAL);
                             } 
{I}{N}{T}{E}{G}{E}{R}        {yylval.string = strdup(yytext); 
                              printf("Shift INTEGER\n"); 
                              return(INTEGER);
                             }
{S}{T}{R}{I}{N}{G}           {yylval.string = strdup(yytext); 
                              printf("Shift STRING\n"); 
                              return(STRING);
                             }                         
[a-zA-Z]([a-zA-Z0-9_])*      {yylval.string = strdup(yytext); 
                              printf("Shift IDENTIFIER\n"); 
                              return(IDENTIFIER);
                             }

":="                         {yylval.string = strdup(yytext); 
                              printf("Shift ASSIGNMENT\n"); 
                              return(ASSIGNMENT);
                             }
":"                          {yylval.string = strdup(yytext); 
                              printf("Shift COLON\n"); 
                              return(COLON);
                             }
","                          {yylval.string = strdup(yytext); 
                              printf("Shift COMMA\n"); 
                              return(COMMA);
                             }
[-]?[0-9]+                  {yylval.number = atoi(yytext); 
                              printf("Shift DIGSEQ\n"); 
                              return(DIGSEQ);
                             }
"."                          {yylval.string = strdup(yytext); 
                              printf("Shift DOT\n"); 
                              return(DOT);
                             }
".."                         {yylval.string = strdup(yytext); 
                              printf("Shift DOTDOT\n"); 
                              return(DOTDOT);
                             }
"="                          {yylval.string = strdup(yytext); 
                              printf("Shift EQUAL\n"); 
                              return(EQUAL);
                             }
"!="                         {yylval.string = strdup(yytext); 
                              printf("Shift NOTEQUAL\n"); 
                              return(notEQUAL);
                             }
">="                         {yylval.string = strdup(yytext); 
                              printf("Shift GE\n"); 
                              return(GE);
                             }
">"                          {yylval.string = strdup(yytext); 
                              printf("Shift GT\n"); 
                              return(GT);
                             }
"["                          {yylval.string = strdup(yytext); 
                              printf("Shift LBRAC\n"); 
                              return(LBRAC);
                             }
"<="                         {yylval.string = strdup(yytext); 
                              printf("Shift LE\n"); 
                              return(LE);
                             }
"("                          {yylval.string = strdup(yytext); 
                              printf("Shift LPAREN\n"); 
                              return(LPAREN);
                             }
"<"                          {yylval.string = strdup(yytext); 
                              printf("Shift LT\n"); 
                              return(LT);
                             }
"-"                          {yylval.string = strdup(yytext); 
                              printf("Shift MINUS\n"); 
                              return(MINUS);
                             }
"+"                          {yylval.string = strdup(yytext); 
                              printf("Shift PLUS\n"); 
                              return(PLUS);
                             }
"]"                          {yylval.string = strdup(yytext); 
                              printf("Shift RBRAC\n"); 
                              return(RBRAC);
                             }
[-]?[0-9]+"."[0-9]+         {yylval.fnumber= atof(yytext); 
                              printf("Shift REALNUMBER\n"); 
                              return(REALNUMBER);
                             }
")"                          {yylval.string = strdup(yytext); 
                              printf("Shift RPAREN\n"); 
                              return(RPAREN);
                             }
";"                          {yylval.string = strdup(yytext); 
                              printf("Shift SEMICOLON\n"); 
                              return(SEMICOLON);
                             }
"/"                          {yylval.string = strdup(yytext); 
                              printf("Shift SLASH\n"); 
                              return(SLASH);
                             }
"*"                          {yylval.string = strdup(yytext); 
                              printf("Shift STAR\n"); 
                              return(STAR);
                             }
"(*"   |
"{"    { register int c;
     while ((c = input()))
     {
      if (c == '}')
       break;
      else if (c == '*')
      {
       if ((c = input()) == ')')
        break;
       else
        unput (c);
      }
      else if (c == '\n')
       lineCount++;
      else if (c == 0)
        fprintf (stderr, "Unexpected EOF inside comment at line %d\n",lineCount);
     }
    }

[-]?[0-9]+("."[0-9]*)?{E}[+-]?[0-9]+ 
{yylval.fnumber= atof(yytext); 
  printf("Shift REALNUMBER\n"); 
  return(REALNUMBER);
}


[ \t\f]    ;

\r         ; 
\n    lineCount++;

.   {fprintf(stderr,"Lexical analyzer error at line %d : %s\n",lineCount,yytext);}


\"[^\"|^\n|^\r|^\t|^\f]*\"  {return (IDENTIFIER);}
\'[^\"|^\n|^\r|^\t|^\f]*\'   {return (IDENTIFIER);}
"//"[^\n]*  {printf("comment: %s\n" , yytext);}





%%

/*int main(int argc, char** argv) {
  int i, tok;
  yyin = fopen("test.txt", "r");
  for (i = 0; 1==1; i ++) {
    tok = yylex();
    fprintf(stderr, "%3d-th token(type:%d) on line %d : %s\n", i, tok,lineCount, yytext);
  }
    return(0);
}*/ 


yywrap() {
  /*fclose(yyin);
  exit(1);*/
}
