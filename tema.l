%{
	#include "y.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%

"PROGRAM"			{ colNo+=7; return TOK_PROGRAM; }
"VAR"				{ colNo+=3; return TOK_VAR; }
"BEGIN"				{ colNo+=5; return TOK_BEGIN; }
"END"				{ colNo+=3; return TOK_END; }
"INTEGER"			{ colNo+=7; return TOK_INTEGER; }
"READ"				{ colNo+=4; return TOK_READ; }
"WRITE"				{ colNo+=5; return TOK_WRITE; }
"FOR"				{ colNo+=3; return TOK_FOR; }
"DO"				{ colNo+=2; return TOK_DO; }
"TO"				{ colNo+=2; return TOK_TO; }

"+"				{ colNo++; return TOK_PLUS; }
"-"				{ colNo++; return TOK_MINUS; }
"*"				{ colNo++; return TOK_MULTIPLY; }
"DIV"				{ colNo++; return TOK_DIVIDE; }
"int"				{ colNo+=3; return TOK_DECLARE; }
"("				{ colNo++; return TOK_LEFT; }
")"				{ colNo++; return TOK_RIGHT; }
";"				{ colNo++; return ';'; }
","				{ colNo++; return ','; }
":"				{ colNo++; return ':'; }
"."				{ colNo++; return '.'; }
":="				{ colNo+=2; return TOK_ATRIB; }
0|[1-9][0-9]*	{ yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val = atoi(yytext); return TOK_NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_ID;}
[ ]				{ colNo++; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
.				{ colNo++;return TOK_ERROR; }
%%