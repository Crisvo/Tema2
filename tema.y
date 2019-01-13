%{
	#include <stdio.h>
        #include <string.h>
	
	int yylex();
	int yyerror(const char *message);

   	int IsCorrect = 1;
	char message[500];

	class TVAR
	{
	     char* name;
	     int value;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;
	     static int read_write;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
         void append(char* n, int v = -1);
         int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;
	int TVAR::read_write = 0;

	TVAR::TVAR(char* n, int v)
	{
	 read_write = 0;
	 this->name = new char[strlen(n) + 1];
	 strcpy(this->name, n);
	 this->value = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  read_write = 0;
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* temp = TVAR::head;
	  while(temp != NULL)
	  {
	    if(strcmp(temp->name,n) == 0)
	      return 1;
            temp = temp->next;
	  }
	  return 0;
	 }

         void TVAR::append(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* temp = TVAR::head;
	   while(temp != NULL)
	   {
	     if(strcmp(temp->name,n) == 0)
	      return temp->value;
	     temp = temp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* temp = TVAR::head;
	    while(temp != NULL)
	    {
	      if(strcmp(temp->name,n) == 0)
	      {
		temp->value = v;
	      }
	      temp = temp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}

%union { char* sir; int val; PUNCT p; }

%token TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END TOK_INTEGER TOK_DECLARE
%token TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_ATRIB
%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT
%token <val> TOK_NUMBER
%token <sir> TOK_ID TOK_ERROR

%type <sir> id_list
%type <val> exp

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%locations

%%

prog :
	|
	TOK_PROGRAM prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END '.'
	{IsCorrect = 1;}
	|
	error ';' prog
	{IsCorrect = 0;}
	;

prog_name : TOK_ID
	;

dec_list : dec
	|
	dec_list ';' dec
	;

dec : id_list ':' type
	;

type : TOK_INTEGER
	;

id_list : TOK_ID
	|
	id_list ',' TOK_ID
	;

stmt_list : stmt
	|
	stmt_list ';' stmt
	;

stmt : assign
	|
	read
	|
	write
	|
	for
	;

assign : TOK_ID TOK_ATRIB exp
	;

exp : term
      |
      exp TOK_PLUS term
      |
      exp TOK_MINUS term
	;

term : factor
	|
	term TOK_MULTIPLY factor
	|
	term TOK_DIVIDE factor
	;

factor : TOK_ID
	|
	TOK_NUMBER
	|
	TOK_LEFT exp TOK_RIGHT
	;

read : TOK_READ TOK_LEFT id_list TOK_RIGHT
	;

write : TOK_WRITE TOK_LEFT id_list TOK_RIGHT
	;

for : TOK_FOR index_exp TOK_DO body
	;

index_exp : TOK_ID TOK_ATRIB exp TOK_TO exp
	;

body : stmt
	|
	TOK_BEGIN stmt_list TOK_END
	;

%%

int main()
{
	yyparse();
	
	if(IsCorrect == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}

int yyerror(const char *message)
{
	printf("Error: %s\n", message);
	return 1;
}