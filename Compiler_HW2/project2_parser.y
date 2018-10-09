%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"

     /* Called by yyparse on error.  */
     void
     yyerror (char const *s)
     {
        extern char *yytext;
        extern int lineCount;
        fprintf (stderr, "%s: at line %d symbol'%s'\n", s,lineCount,yytext);
     }
     struct nodeType *ROOT;
%}


%token <string>  PROGRAM IDENTIFIER COMMA VAR COLON ARRAY INTEGER REAL isstring 
%token <string>  FUNCTION PROCEDURE LPAREN RPAREN SEMICOLON PBEGIN DOT 
%token <string>  END ASSIGNMENT IF THEN ELSE WHILE DO LBRAC RBRAC STRING
%token <string>  PLUS MINUS STAR SLASH LT GT EQUAL LE GE notEQUAL DOTDOT NOT OF
%token <number>  DIGSEQ
%token <fnumber> REALNUMBER 				//<-CHECK PRIORITY!!!!!!!!!!!!

%union 
{ 
    struct nodeType * node;
    int number;
    double fnumber;
    char * string;
}
%type<node> prog  identifier_list  declarations  type  standard_type  subprogram_declarations    
%type<node> subprogram_declaration  subprogram_head  arguments  parameter_list  optional_var 
%type<node> compound_statement  optional_statements  statement_list  statement  variable  tail  
%type<node> procedure_statement  expression_list  expression  simple_expression  term
%type<node> factor  addop  mulop  relop

%%

prog : PROGRAM IDENTIFIER LPAREN identifier_list RPAREN SEMICOLON
  	    declarations
	    subprogram_declarations
	    compound_statement
	    DOT{
	    	fprintf(stderr, "Use rule 1 reduction.\n");
	    	$$=newNode(NODE_PROGRAM);
	    	struct nodeType *id=newNode(NODE_IDENTIFIER);
            id->string=$2;
            addChild($$ , id);
            addChild($$ , newNode(NODE_LPAREN));
            addChild($$ , $4);
            addChild($$ , newNode(NODE_RPAREN));
            addChild($$ , newNode(NODE_SEMICOLON));
            addChild($$ , $7);
            addChild($$ , $8);
            addChild($$ , $9);
            addChild($$ , newNode(NODE_DOT)); 
            ROOT = $$;
	    };
	    


identifier_list : 
	IDENTIFIER{
		fprintf(stderr, "Use rule 2 reduction.\n");
		$$=newNode(NODE_ID_LIST);
		struct nodeType *id=newNode(NODE_IDENTIFIER) ;
		id->string=$1;
		addChild($$ , id);
	};
	| identifier_list COMMA IDENTIFIER{
		fprintf(stderr, "Use rule 3 reduction.\n");
		$$=newNode(NODE_ID_LIST);
		addChild($$ , $1);	
		addChild($$ , newNode(NODE_COMMA));
        struct nodeType *id=newNode(NODE_IDENTIFIER) ;
        id->string=$3;
        addChild($$ , id);  
	};


declarations : 
	declarations VAR identifier_list COLON type SEMICOLON{
		fprintf(stderr, "Use rule 4 reduction.\n");
		$$ = $1;	//
		addChild($1 , newNode(NODE_VAR));
        addChild($1 , $3);
        addChild($1 , newNode(NODE_COLON));
        addChild($1 , $5);
        addChild($1 , newNode(NODE_SEMICOLON));
	};
	| lambda {
		fprintf(stderr, "Use rule 5 reduction.\n");
		$$ = newNode(NODE_LAMBDA);
	};


type : 
	standard_type{
		fprintf(stderr, "Use rule 6 reduction.\n");
        $$ = newNode(NODE_TYPE);	
        addChild($$ , $1);
	};
	| ARRAY LBRAC DIGSEQ DOTDOT DIGSEQ RBRAC OF type{
		fprintf(stderr, "Use rule 7 reduction.\n");
		$$ = newNode(NODE_TYPE);
        addChild($$ , newNode(NODE_ARRAY));
        addChild($$ , newNode(NODE_LBRAC));
        struct nodeType *dig = newNode(NODE_DIGSEQ);
        dig->iValue = $3;
        addChild($$ , dig);
        addChild($$ , newNode(NODE_DOTDOT));
        struct nodeType *dig2 = newNode(NODE_DIGSEQ);
        dig2->iValue = $5;
        addChild($$ , dig2);
        addChild($$ , newNode(NODE_RBRAC));
        addChild($$ , newNode(NODE_OF));
        addChild($$ , $8); 
	};


standard_type : 
	INTEGER{
		fprintf(stderr, "Use rule 8 reduction.\n");
		$$=newNode(NODE_INTEGER);
	};
	| REAL{
		fprintf(stderr, "Use rule 9 reduction.\n");
		$$=newNode(NODE_REAL);
	};
    | STRING{
    	fprintf(stderr, "Use rule 10 reduction.\n");
    	$$=newNode(NODE_STRING);
    };


subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON{
		fprintf(stderr, "Use rule 11 reduction.\n");
		$$ = $1;			//<-_->
		addChild($1 , $2);	//
        addChild($1 , newNode(NODE_SEMICOLON)); 
	};
	| lambda{
		fprintf(stderr, "Use rule 12 reduction.\n");
		$$ = newNode(NODE_LAMBDA);
	};


subprogram_declaration :
	subprogram_head 
	declarations 	
    compound_statement{
    	fprintf(stderr, "Use rule 13 reduction.\n");
		$$ = newNode(NODE_SUBDEC);	//<-.->
        addChild($$ , $1);
        addChild($$ , $2);
        addChild($$ , $3);     	
    };

subprogram_head : 
	FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON{
		fprintf(stderr, "Use rule 14 reduction.\n");
		$$ = newNode(NODE_SUBPROGRAM);
        addChild($$ , newNode(NODE_FUNCTION));
        struct nodeType *id=newNode(NODE_IDENTIFIER);
        id->string = $2;
        addChild($$ , id);
        addChild($$ , $3);
        addChild($$ , newNode(NODE_COLON));
        addChild($$ , $5);
        addChild($$ , newNode(NODE_SEMICOLON)); 
	};
	| PROCEDURE IDENTIFIER arguments SEMICOLON{
		fprintf(stderr, "Use rule 15 reduction.\n");
		$$ = newNode(NODE_SUBPROGRAM);
        addChild($$ , newNode(NODE_PROCEDURE));
        struct nodeType *id=newNode(NODE_IDENTIFIER);
        id->string = $2;
        addChild($$ , id);
        addChild($$ , $3);
        addChild($$ , newNode(NODE_SEMICOLON));
	};


arguments : 
	LPAREN parameter_list RPAREN{
		fprintf(stderr, "Use rule 16 reduction.\n");
		$$ = newNode(NODE_ARGUMENT);
        addChild($$ , newNode(NODE_LPAREN));
        addChild($$ , $2);
        addChild($$ , newNode(NODE_RPAREN));
	};
	| lambda {
		fprintf(stderr, "Use rule 17 reduction.\n");
		$$ = newNode(NODE_LAMBDA);
	};


parameter_list : 
	optional_var identifier_list COLON type{
		fprintf(stderr, "Use rule 18 reduction.\n");
		$$ = newNode(NODE_PARAMETER);
        addChild($$ , $1);
        addChild($$ , $2);
        addChild($$ , newNode(NODE_COLON));
        addChild($$ , $4);
	};
	| optional_var identifier_list COLON type SEMICOLON parameter_list {
		fprintf(stderr, "Use rule 19 reduction.\n");
		$$ = newNode(NODE_PARAMETER);
		addChild($$ , $1);		
        addChild($$ , $2);
        addChild($$ , newNode(NODE_COLON));
        addChild($$ , $4);
        addChild($$ , newNode(NODE_SEMICOLON));
        addChild($$ , $6);
	};


optional_var : 
	VAR{
		fprintf(stderr, "Use rule 20 reduction.\n");
		$$ = newNode(NODE_VAR);
	};
    | lambda {
    	fprintf(stderr, "Use rule 21 reduction.\n");
    	$$ = newNode(NODE_LAMBDA);
    };


compound_statement : 
	PBEGIN
	optional_statements
	END{
		fprintf(stderr, "Use rule 22 reduction.\n");
		$$ = newNode(NODE_COMPOUND);
        addChild($$ , newNode(NODE_BEGIN));
        addChild($$ , $2);
        addChild($$ , newNode(NODE_END));
	};


optional_statements : 
	statement_list{
		fprintf(stderr, "Use rule 23 reduction.\n");
		$$ = newNode(NODE_OPTIONAL);
		addChild($$ , $1);
		//<-_->
	};
	

statement_list : 
	statement {
		fprintf(stderr, "Use rule 24 reduction.\n");
		$$ = newNode(NODE_STMTLIST);
        addChild($$ , $1);
        //<-_->
	};
	| statement_list SEMICOLON statement{
		fprintf(stderr, "Use rule 25 reduction.\n");
		addChild($1 , newNode(NODE_SEMICOLON));
        addChild($1 , $3);
        $$ = $1;
	};


statement : 
	variable ASSIGNMENT expression{
		fprintf(stderr, "Use rule 26 reduction.\n");
		$$ = newNode(NODE_STMT);
        addChild($$ , $1);
        addChild($$ , newNode(NODE_ASSIGNMENT));
        addChild($$ , $3);
	};
	| procedure_statement {
		fprintf(stderr, "Use rule 27 reduction.\n");
		$$ = newNode(NODE_STMT);
		addChild($$ , $1);		//<-_->
        
	};
	| compound_statement{
		fprintf(stderr, "Use rule 28 reduction.\n");
		$$ = newNode(NODE_STMT);
		addChild($$ , $1);
        //<-_->
	};
	| IF expression THEN statement ELSE statement {
		fprintf(stderr, "Use rule 29 reduction.\n");
		$$ = newNode(NODE_STMT);
        addChild($$ , newNode(NODE_IF));
        addChild($$ , $2);
        addChild($$ , newNode(NODE_THEN));
        addChild($$ , $4);
        addChild($$ , newNode(NODE_ELSE));
        addChild($$ , $6);
	};
	| WHILE expression DO statement {
		fprintf(stderr, "Use rule 30 reduction.\n");
		$$ = newNode(NODE_STMT);
        addChild($$ , newNode(NODE_WHILE));
        addChild($$ , $2);
        addChild($$ , newNode(NODE_DO));
        addChild($$ , $4);
	};
	| lambda {
		fprintf(stderr, "Use rule 31 reduction.\n");
		$$ = newNode(NODE_LAMBDA);
	};


variable : 
	IDENTIFIER tail {
		fprintf(stderr, "Use rule 32 reduction.\n");
		$$ = newNode(NODE_VARIABLE);
		struct nodeType *id= newNode(NODE_IDENTIFIER);
        id->string = $1;
        addChild($$ , id);
        addChild($$ , $2);
	};

tail  : 
	LBRAC expression RBRAC tail {
		fprintf(stderr, "Use rule 33 reduction.\n");
        addChild($4 , newNode(NODE_LBRAC));
        addChild($4 , $2);
        addChild($4 , newNode(NODE_RBRAC));
        $$ = $4;
	};
	| lambda {
		fprintf(stderr, "Use rule 34 reduction.\n");
		$$ = newNode(NODE_LAMBDA);
	};


procedure_statement : 
	IDENTIFIER {
		fprintf(stderr, "Use rule 35 reduction.\n");
		$$ = newNode(NODE_IDENTIFIER);
        $$->string = $1;
	};
	| IDENTIFIER LPAREN expression_list RPAREN {
		fprintf(stderr, "Use rule 36 reduction.\n");
		$$ = newNode(NODE_PROSTMT);
        struct nodeType *id= newNode(NODE_IDENTIFIER);
        id->string = $1;
        addChild($$ , id);
        addChild($$ , newNode(NODE_LPAREN));
        addChild($$ , $3);
        addChild($$ , newNode(NODE_RPAREN));
	};


expression_list : 
	expression {
		fprintf(stderr, "Use rule 37 reduction.\n");
        $$ = newNode(NODE_EXPLIST);
        addChild($$ , $1);		//<-_->
	};
	| expression_list COMMA expression {
		fprintf(stderr, "Use rule 38 reduction.\n");
        addChild($1 , newNode(NODE_COMMA));
        addChild($1 , $3);
        $$ = $1;
	};


expression : 
	simple_expression {
		fprintf(stderr, "Use rule 39 reduction.\n");
        $$ = newNode(NODE_EXP);
        addChild($$ , $1);		//<-_->
	};
	| simple_expression relop simple_expression {
		fprintf(stderr, "Use rule 40 reduction.\n");
		$$ = newNode(NODE_EXP);
        addChild($$ , $1);
        addChild($$ , $2);
        addChild($$ , $3);
	};


simple_expression : 
	term {
		fprintf(stderr, "Use rule 41 reduction.\n");	
        $$ = newNode(NODE_SIMPLE);
        addChild($$ , $1);
	};
	| simple_expression addop term {
		fprintf(stderr, "Use rule 42 reduction.\n");
        addChild($1 , $2);		
        addChild($1 , $3);
        $$ = $1;
	};


term : 
	factor {
		fprintf(stderr, "Use rule 43 reduction.\n");
        $$ = newNode(NODE_TERM);
        addChild($$ , $1);
	};
	| term mulop factor {
		fprintf(stderr, "Use rule 44 reduction.\n");
		addChild($1 , $2);
        addChild($1 , $3);
        $$ = $1;
	};


factor : 
	IDENTIFIER tail {
		fprintf(stderr, "Use rule 45 reduction.\n");
		$$ = newNode(NODE_FACTOR);
        struct nodeType *id= newNode(NODE_IDENTIFIER);
        id->string = $1;
        addChild($$ , id);
        addChild($$ , $2);
	};
	| IDENTIFIER LPAREN expression_list RPAREN{
		fprintf(stderr, "Use rule 46 reduction.\n");
		$$ = newNode(NODE_FACTOR);
        struct nodeType *id=newNode(NODE_IDENTIFIER);
        id->string = $1;
        addChild($$ , id);
        addChild($$ , newNode(NODE_LPAREN));
        addChild($$ , $3);
        addChild($$ , newNode(NODE_RPAREN));
	};
	| PLUS DIGSEQ{
		fprintf(stderr, "Use rule 47 reduction.\n");
		$$ = newNode(NODE_FACTOR);
		addChild($$ , newNode(OP_ADD));
		struct nodeType *dig=newNode(NODE_DIGSEQ);
		dig->iValue = $2;
		addChild($$ , dig);
	};
	| MINUS DIGSEQ{
		fprintf(stderr, "Use rule 48 reduction.\n");
		$$ = newNode(NODE_FACTOR);
		addChild($$ , newNode(OP_SUB));
		struct nodeType *dig=newNode(NODE_DIGSEQ);
		dig->iValue = $2;
		addChild($$ , dig);
	};
	| DIGSEQ {
		fprintf(stderr, "Use rule 49 reduction.\n");
		$$ = newNode(NODE_FACTOR);
		struct nodeType *dig=newNode(NODE_DIGSEQ);
		dig->iValue = $1;
		addChild($$ , dig);
	};
	| REALNUMBER {
        fprintf(stderr, "Use rule 50 reduction.\n");
        $$ = newNode(NODE_FACTOR);
        struct nodeType *real= newNode(NODE_REALNUMBER);
        real->rValue = $1;
        addChild($$ , real);
    };
	| LPAREN expression RPAREN {
		fprintf(stderr, "Use rule 51 reduction.\n");
		$$ = newNode(NODE_FACTOR);
        addChild($$ , newNode(NODE_LPAREN));
        addChild($$ , $2);
        addChild($$ , newNode(NODE_RPAREN));
	};
	| NOT factor {
		fprintf(stderr, "Use rule 52 reduction.\n");
        addChild($2 , newNode(NODE_NOT));
        $$=$2;		//<-_->
	};


addop : 
	PLUS {
		fprintf(stderr, "Use rule 53 reduction.\n");
		$$ = newNode(OP_ADD);
        $$->string = $1;
	};
	| MINUS{
		fprintf(stderr, "Use rule 54 reduction.\n");
		$$ = newNode(OP_SUB);
        $$->string = $1;
	};


mulop : 
	STAR {
		fprintf(stderr, "Use rule 55 reduction.\n");
		$$ = newNode(OP_MUL);
        $$->string = $1;
	};
	| SLASH{
		fprintf(stderr, "Use rule 56 reduction.\n");
		$$ = newNode(OP_DIV);
        $$->string = $1;
	};



relop : 
	LT {
		fprintf(stderr, "Use rule 57 reduction.\n");
		$$ = newNode(NODE_LT);
        $$->string = $1;
	};
	| GT {
		fprintf(stderr, "Use rule 58 reduction.\n");
		$$ = newNode(NODE_GT);
        $$->string = $1; 
	};
	| EQUAL {
		fprintf(stderr, "Use rule 59 reduction.\n");
		$$ = newNode(NODE_EQUAL);
        $$->string = $1;
	};
	| LE {
		fprintf(stderr, "Use rule 60 reduction.\n");
		$$ = newNode(NODE_LE);
        $$->string = $1;
	};
	| GE {
		fprintf(stderr, "Use rule 61 reduction.\n");
		$$ = newNode(NODE_GE);
        $$->string = $1;
	};
	| notEQUAL {
		fprintf(stderr, "Use rule 62 reduction.\n");
		$$ = newNode(NODE_notEQUAL);
        $$->string = $1;
	};

lambda :

%%

int main(int argc, char** argv) {
    int res;
    
    fprintf(stderr, "open file.\n");
    if(argc>1 && freopen(argv[1],"r",stdin)==NULL){
        exit(1);
    }
    
    fprintf(stderr, "call yyparse\n");
    res = yyparse();
    fprintf(stderr, "after call yyparse, res = %d.\n", res);
    
    if (res==0)
        fprintf(stderr, "SUCCESS\n");
    else
        fprintf(stderr, "ERROR\n");
    printf("\n\n");
    printTree(ROOT, 0);
}

 #include "lex.yy.c"