#ifndef __NODE_H__
#define __NODE_H__

struct nodeType;
enum ntype {
    VALUE_INVALID,                       
    OP_ADD, 
    OP_SUB, 
    OP_MUL, 
    OP_DIV,
    NODE_DIGSEQ,
    NODE_REALNUMBER,
    NODE_VAR,
    NODE_INTEGER,
    NODE_REAL,
    NODE_STRING,
    NODE_IDENTIFIER,
    NODE_FACTOR,
    NODE_NOT,
    NODE_LPAREN,
    NODE_RPAREN,
    NODE_SIMPLE,
    NODE_EXP,
    NODE_EXPLIST,
    NODE_COMMA,
    NODE_LBRAC,
    NODE_RBRAC,
    NODE_TAIL,
    NODE_WHILE,
    NODE_DO,
    NODE_IF,
    NODE_ELSE,
    NODE_COMPOUND,
    NODE_PROSTMT,
    NODE_ASSIGNMENT,
    NODE_STMTLIST,
    NODE_SEMICOLON,
    NODE_OPTIONAL,
    NODE_BEGIN,
    NODE_END,
    NODE_COLON,
    NODE_PROCEDURE,
    NODE_FUNCTION,
    NODE_STAN,
    NODE_ARRAY,
    NODE_DOTDOT,
    NODE_OF,
    NODE_TYPE,
    NODE_DOT,
    NODE_STMT,
    NODE_TERM,
    NODE_PROGRAM,
    NODE_LT,
    NODE_GE,
    NODE_GT,
    NODE_LE,
    NODE_EQUAL,
    NODE_notEQUAL,
    NODE_THEN,
    NODE_VARIABLE,
    NODE_PARAMETER,
    NODE_ARGUMENT,
    NODE_SUBPROGRAM,
    NODE_ID_LIST,
    NODE_SUBDECS,
    NODE_SUBDEC,
    NODE_STAR,
    NODE_SLASH,
    NODE_LAMBDA
};

// #include "symtab.h"
struct nodeType {
    int nodeType;
    struct nodeType *parent;
    struct nodeType *child;
    struct nodeType *lsibling;
    struct nodeType *rsibling;

    /* Attribute for NODE_TOKEN */
    int tokenType;

    /* items for Array */
    int idxstart;
    int idxend;
    int arraydepth;
    struct nodeType *ref;

    /* Values for general use */
    int iValue;
    double rValue;
    char valueValid;
    char *string;
    
    /* Indicates which OP */
    char op;

};

struct nodeType* newNode(int type);
void deleteNode(struct nodeType* node);
void addChild(struct nodeType *node, struct nodeType *child);
void printTree(struct nodeType *node, int ident);

#endif

