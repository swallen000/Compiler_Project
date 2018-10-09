#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "node.h"

struct nodeType* newNode(int type) {
    struct nodeType *node = (struct nodeType*)malloc(sizeof(struct nodeType));
    node->nodeType = type;
    node->valueValid = VALUE_INVALID;
    node->string = NULL;
    node->parent = NULL;
    node->child = NULL;
    node->lsibling = node;
    node->rsibling = node;

    return node;
}

void addChild(struct nodeType *node, struct nodeType *child) {
    child->parent = node;

    if(node->child == NULL) {
        node->child = child;
    }
    else {
        child->lsibling = node->child->lsibling;
        child->rsibling = node->child;
        node->child->lsibling->rsibling = child;
        node->child->lsibling = child;
    }
}

void deleteNode(struct nodeType *node) {
    if(node->string != NULL)
        free(node->string);
    free(node);
}

void printTree(struct nodeType *node, int ident) {
    static char blank[1024];
    for(int i=0; i<ident; i++)
        blank[i] = ' ';
    blank[ident] = 0;

    switch(node->nodeType) {
        case OP_ADD:
            printf("%s/ADD\n", blank);
            break;
        case OP_SUB:
            printf("%s/SUB\n", blank);
            break;
        case OP_MUL:
            printf("%s/MUL\n", blank);
            break;
        case OP_DIV:
            printf("%s/DIV\n", blank);
            break;
        case NODE_DIGSEQ:
            printf("%s%d\n", blank, node->iValue);
            ident += 8;
            break;
        case NODE_REALNUMBER: 
            printf("%s%g\n", blank, node->rValue);
            ident += 8;
            break;
        case NODE_VAR:  
            printf("%sVAR\n", blank);
            ident += 8;
            break;
        case NODE_INTEGER:
            printf("%sinteger\n", blank);
            ident += 8;
            break;
        case NODE_REAL:
            printf("%sreal\n", blank);
            ident += 8;
            break;
        case NODE_STRING:
            printf("%sstring\n", blank);
            ident += 8;
            break;
        case NODE_IDENTIFIER:
            printf("%s%s\n" , blank , node->string);
            ident += 8;
            break;
        case NODE_FACTOR:
            printf("%s/factor\n", blank);
            ident += 8;
            break;
        case NODE_NOT:
            printf("%sNOT\n", blank);
            ident += 8;
            break;
        case NODE_LPAREN:
            printf("%s(\n", blank);
            ident += 8;
            break;
        case NODE_RPAREN:
            printf("%s)\n", blank);
            ident += 8;
            break;
        case NODE_SIMPLE:
            printf("%s/simple expression \n", blank);
            ident += 8;
            break;
        case NODE_EXP:
            printf("%s/expression \n", blank);
            ident += 8;
            break;
        case NODE_EXPLIST:
            printf("%s/expression_list\n", blank);
            ident += 8;
            break;
        case NODE_COMMA:
            printf("%s,\n", blank);
            ident += 8;
            break;
        case NODE_LBRAC:
            printf("%s[\n", blank);
            ident += 8;
            break;
        case NODE_RBRAC:
            printf("%s]\n", blank);
            ident += 8;
            break;
        case NODE_TAIL:
            printf("%s/tail\n", blank);
            ident += 8;
            break;
        case NODE_WHILE:
            printf("%sWHILE\n", blank);
            ident += 8;
            break;
        case NODE_DO:
            printf("%sDO\n", blank);
            ident += 8;
            break;
        case NODE_IF:
            printf("%sIF\n", blank);
            ident += 8;
            break;
        case NODE_ELSE:
            printf("%sELSE\n", blank);
            ident += 8;
            break;
        case NODE_COMPOUND:
            printf("%s/compound_statement\n", blank);
            ident += 8;
            break;
        case NODE_PROSTMT:
            printf("%s/procedure_statement\n", blank);
            ident += 8;
            break;
        case NODE_ASSIGNMENT:
            printf("%s:=\n", blank);
            ident += 8;
            break;
        case NODE_STMTLIST:
            printf("%s/statement_list\n", blank);
            ident += 8;
            break;
        case NODE_SEMICOLON:
            printf("%s;\n", blank);
            ident += 8;
            break;
        case NODE_OPTIONAL:
            printf("%s/optional_statements\n", blank);
            ident += 8;
            break;
        case NODE_BEGIN:
            printf("%sBEGIN\n", blank);
            ident += 8;
            break;
        case NODE_END:
            printf("%sEND\n", blank);
            ident += 8;
            break;
        case NODE_COLON: 
            printf("%s:\n", blank);
            ident += 8;
            break;
        case NODE_PROCEDURE:
            printf("%sPROCEDURE\n", blank);
            ident += 8;
            break;
        case NODE_FUNCTION:
            printf("%sFUNCTION\n", blank);
            ident += 8;
            break;
        case NODE_STAN:
            printf("%s/standard_type\n", blank);
            ident += 8;
            break;
        case NODE_ARRAY:
            printf("%sARRAY\n", blank);
            ident += 8;
            break;
        case NODE_DOTDOT:
            printf("%s../n", blank);
            ident += 8;
            break;
        case NODE_OF:
            printf("%sOF\n", blank);
            ident += 8;
            break;
        case NODE_TYPE:
            printf("%s/type\n", blank);
            ident += 8;
            break;
        case NODE_DOT:
            printf("%s.\n", blank);
            ident += 8;
            break;
        case NODE_STMT:
            printf("%s/STMT\n", blank);
            ident += 8;
            break;
        case NODE_TERM:
            printf("%s/TERM\n", blank);
            ident += 8;
            break;
        case NODE_PROGRAM:
            printf("%s/PROGRAM\n", blank);
            ident += 8;
            break;
        case NODE_LT:
            printf("%s < \n" , blank);
            ident += 8;
            break;
        case NODE_GE:
            printf("%s >=\n" , blank);
            ident += 8;
            break;
        case NODE_GT:
            printf("%s >\n" , blank);
            ident += 8;
            break;
        case NODE_LE:
            printf("%s <=\n" , blank);
            ident += 8;
            break;
        case NODE_EQUAL:
            printf("%s =\n" , blank);
            ident += 8;
            break;
        case NODE_notEQUAL:
            printf("%s !=\n" , blank);
            ident += 8;
            break;
        case NODE_THEN:
            printf("%s THEN\n" , blank);
            ident += 8;
            break;
        case NODE_VARIABLE:
            printf("%s /variable\n" , blank);
            ident += 8;
            break;
        case NODE_PARAMETER:
            printf("%s /parameter_list\n" , blank);
            ident += 8;
            break;
        case NODE_ARGUMENT:
            printf("%s /arguments\n" , blank);
            ident += 8;
            break;
        case NODE_SUBPROGRAM:
            printf("%s /subprogram_head\n" , blank);
            ident += 8;
            break;
        case NODE_ID_LIST:
            printf("%s /identifier_list\n" , blank);
            ident += 8;
            break;       
        case NODE_SUBDECS:
            printf("%s /subprogram_declarations\n" , blank);
            ident += 8;
            break;
        case NODE_SUBDEC:
            printf("%s /subprogram_declaration\n" , blank);
            ident += 8;
            break;   
        case NODE_LAMBDA:
            printf("\n");
            break;   
        default:
            printf("%sdefault:%d\n", blank, node->nodeType);
          break;
    }

    struct nodeType *child = node->child;
    if(child != NULL) {
        do {
            printTree(child, ident);
            child = child->rsibling;
        } while(child != node->child);
    }
}

