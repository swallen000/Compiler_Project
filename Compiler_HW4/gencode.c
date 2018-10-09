#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "header.h"
#include "semcheck.h"
#include "symtab.h"
#include "gencode.h"


int loop_label=0;
int counter_label=0;
int loop_stack[100];
int stack[100];
int loop_label;
int pos_stack;
int pos_loop_stack=0;




void pgstart(char* name){
	fprintf(opfile,"; %s.j\n", name);
	fprintf(opfile,".class public %s\n", name);
	fprintf(opfile,".super java/lang/Object\n");
	fprintf(opfile,".field public static _sc Ljava/util/Scanner;\n\n");
}

void gglobalv(char* name, struct PType* type)
{
	if(type->type == INTEGER_t){
		fprintf(opfile, ".field public static %s I\n", name);
	}
	else if(type->type == BOOLEAN_t){
		fprintf(opfile, ".field public static %s Z\n", name);
	}
	else if(type->type == REAL_t){
		fprintf(opfile, ".field public static %s F\n", name);
	}
}

void mainmethod(char* name, char* para, char* fu){
	fprintf(opfile, ".method public static %s(%s)%s", name, para, fu);
	fprintf(opfile, ".limit stack 100" );

}




void funcdec(char* id, struct param_sem* paras,struct PType* r){
	struct param_sem *pptr;
	struct idNode_sem *idptr;
	fprintf(opfile, ".method public static %s(", id);
	for(pptr=paras;pptr!=0;pptr=(pptr->next)){
		for(idptr=(pptr->idlist);idptr!=0;idptr=(idptr->next)){
			if(pptr->pType->type==INTEGER_t){
				fprintf(opfile,"I");
			}
			else if(pptr->pType->type==REAL_t){
				fprintf(opfile,"F");
			}
			else if(pptr->pType->type==BOOLEAN_t){
				fprintf(opfile,"Z");
			}
		}
	}

	if(r->type==INTEGER_t){
		fprintf(opfile, ")I\n");
	}
	else if(r->type==REAL_t){
		fprintf(opfile, ")F\n");
	}
	else if(r->type==BOOLEAN_t){
		fprintf(opfile, ")Z\n");
	}
	else{
		fprintf(opfile, ")V\n");
	}
	fprintf(opfile, ".limit stack 100\n");
	fprintf(opfile, ".limit locals 100\n");
}


void storeexpr(struct expr_sem* expr, struct expr_sem* rhs){
	struct SymNode* node = lookupSymbol(symbolTable, expr->varRef->id,scope,__FALSE);
	if(expr->varRef){
		if(node!=NULL){
			if(node->category==VARIABLE_t){
				if(node->scope==0){
					if(expr->pType->type==INTEGER_t){
						fprintf(opfile, "putstatic %s/%s I\n", fileName, node->name);
					}
					else if(expr->pType->type==REAL_t){
						if((rhs!=0) && rhs->pType->type==INTEGER_t){
							fprintf(opfile, "i2f\nputstatic %s/%s F\n", fileName, node->name);
						}
						else{
							fprintf(opfile, "putstatic %s/%s F\n", fileName, node->name);
						}
					}
					else if(expr->pType->type==BOOLEAN_t){
						fprintf(opfile, "putstatic %s/%s Z\n", fileName, node->name);
					}
				}
				else if(node->scope!=0){
					if(expr->pType->type==INTEGER_t){
						fprintf(opfile, "istore %d \n", node->sid);
					}
					else if(expr->pType->type==REAL_t){
						if((rhs!=0) && rhs->pType->type==INTEGER_t){
							fprintf(opfile, "i2f\nfstore %d\n", node->sid);
						}
						else{
							fprintf(opfile, "fstore %d\n", node->sid);
						}
					}
					else if(expr->pType->type==BOOLEAN_t){
						fprintf(opfile, "istore %d \n", node->sid);
					}
				}
			}
		}
	}
}

void printfunc(struct expr_sem* ex){
	struct SymNode *node;
	/*fprintf(opfile, "abbbbbbbbb%u\n", ex->pType->type);
	if(ex->pType->type!=CONSTANT_t){
	//node = lookupSymbol(symbolTable, ex->varRef->id, 0, __FALSE);*/

		if(ex->pType->type==INTEGER_t){
			fprintf(opfile, "invokevirtual java/io/PrintStream/print(I)V\n");
		}
		else if(ex->pType->type==STRING_t){
			fprintf(opfile, "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n");
		}
		else if(ex->pType->type==REAL_t){
			fprintf(opfile, "invokevirtual java/io/PrintStream/print(F)V\n");
		}
		else if(ex->pType->type==BOOLEAN_t){
			fprintf(opfile, "invokevirtual java/io/PrintStream/print(Z)V\n");
		}

	
	/*else{
		fprintf(opfile, "ldc \"%s\"",)
	}*/
}

void readfunc(struct expr_sem* expr){
	/*fprintf(opfile, "new java/util/Scanner\n");
	fprintf(opfile, "dup\n");
	fprintf(opfile, "getstatic java/lang/System/in Ljava/io/InputStream;\n");
	fprintf(opfile, "invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V\n");
	fprintf(opfile, "putstatic %s/_sc Ljava/util/Scanner;\n\n",fileName);
	fprintf(opfile, "getstatic %s/_sc Ljava/util/Scanner;\n",fileName);*/
	fprintf(opfile, "getstatic %s/_sc Ljava/util/Scanner;\n",fileName);
	struct SymNode* node = lookupSymbol(symbolTable, expr->varRef->id,scope,__FALSE);
	if(expr->varRef){
		if(expr->varRef){
			if(node->category==VARIABLE_t){
				if(node->scope==0){
					if(expr->pType->type==INTEGER_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextInt()I\n");
					}
					else if(expr->pType->type==REAL_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextFloat()F\n");
					}
					else if(expr->pType->type==BOOLEAN_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextBoolean()Z\n");
					}
				}
				else if(node->scope!=0){
					if(expr->pType->type==INTEGER_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextInt()I\n");
					}
					else if(expr->pType->type==REAL_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextFloat()F\n");
					}
					else if(expr->pType->type==BOOLEAN_t){
						fprintf(opfile, "invokevirtual java/util/Scanner/nextBoolean()Z\n");
					}
				}
			}
		}
	}
}


void funccall(char* id){
	struct SymNode *node;
	node = lookupSymbol(symbolTable, id, 0, __FALSE);
	struct PTypeList* pptr;
	if(node!=0){
		fprintf(opfile, "invokestatic %s/%s(", fileName, id);
		for(pptr=node->attribute->formalParam->params; pptr!=0; pptr=(pptr->next)){
			if(pptr->value->type==INTEGER_t){
				fprintf(opfile, "I");
			}
			else if(pptr->value->type==REAL_t){
				fprintf(opfile, "F");
			}
			else if(pptr->value->type==BOOLEAN_t){
				fprintf(opfile, "Z");
			}
		}
		if(node->type->type==INTEGER_t){
			fprintf(opfile, ")I\n");
		}
		else if(node->type->type==REAL_t){
			fprintf(opfile, ")F\n");
		}
		else if(node->type->type==BOOLEAN_t){
			fprintf(opfile, ")Z\n");
		}
		else{
			fprintf(opfile, ")V\n");
		}

	}
}

void funcend(struct PType* r){
	if(r->type==INTEGER_t){
		fprintf(opfile, "ireturn\n");
	}
	else if(r->type==REAL_t){
		fprintf(opfile, "freturn\n");
	}
	else if(r->type==BOOLEAN_t){
		fprintf(opfile, "ireturn\n");
	}
	else{
		fprintf(opfile, "return\n");
	}
	fprintf(opfile, ".end method\n");
}


void forloop(char* id, int sta, int end){
	//pos_stack++;
	//loop_label=counter_label;
	counter_label++;
	pos_loop_stack++;
	loop_stack[pos_loop_stack]=counter_label;
	struct SymNode *pptr;
	pptr=lookupLoopVar(symbolTable, id);
	if(pptr!=0){
		fprintf(opfile,"ldc %d\nistore %d\nLbegin%d:\niload %d\nsipush %d\nisub\n", sta, pptr->sid, loop_stack[pos_loop_stack], pptr->sid, end+1);
		fprintf(opfile, "iflt Ltrue%d\niconst_0\ngoto Lfalse%d\n", loop_stack[pos_loop_stack], loop_stack[pos_loop_stack]);
		fprintf(opfile,"Ltrue%d:\niconst_1\nLfalse%d:\nifeq Lexit%d\n", loop_stack[pos_loop_stack], loop_stack[pos_loop_stack],loop_stack[pos_loop_stack]);
		//fprintf(opfile,"iload %d\nsipush 1\niadd\nistore %d\ngoto Lbegin%d\nLexit%d:\n", pptr->sid, pptr->sid, loop_stack[pos_loop_stack], loop_stack[pos_loop_stack]);
	}
}

void forend(char* id, int sta, int end){
	struct SymNode *pptr;
	pptr=lookupLoopVar(symbolTable, id);
	if(pptr!=0){
	fprintf(opfile,"iload %d\nsipush 1\niadd\nistore %d\ngoto Lbegin%d\nLexit%d:\n", pptr->sid, pptr->sid, loop_stack[pos_loop_stack], loop_stack[pos_loop_stack]);
	}
	if(pos_loop_stack>1){
		pos_loop_stack--;
		
	}
}


void constload(struct ConstAttr* constl){
	if(constl->category==INTEGER_t){
		fprintf(opfile, "ldc %d\n",constl->value.integerVal);
	}
	else if(constl->category==STRING_t){
		fprintf(opfile, "ldc \"%s\"\n", constl->value.stringVal);
	}
	else if(constl->category==REAL_t){
		fprintf(opfile, "ldc %lf\n", constl->value.realVal);
	}
	else if(constl->category==BOOLEAN_t){
		fprintf(opfile, "iconst_%d\n", constl->value.booleanVal);
	}
			
}


void boolean( struct expr_sem *op1, OPERATOR op, struct expr_sem *op2){
	if(op==AND_t){
		fprintf(opfile, "iand\n");
	}
	else if(op==OR_t){
		fprintf(opfile, "ior\n");
	}
	else if(op==NOT_t){
		fprintf(opfile, "iconst_1\nixor\n");
	}

}



void relat(struct expr_sem *op1, OPERATOR op, struct expr_sem *op2){
	counter_label++;
	pos_loop_stack++;
	loop_stack[pos_loop_stack]=counter_label;
	if(op1->pType->type==INTEGER_t){
		fprintf(opfile, "isub\n");
	}
	else if(op1->pType->type == REAL_t){
		fprintf(opfile, "fcmpl\n");
	}
	if(op==LT_t){
		fprintf(opfile, "iflt Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	else if(op==LE_t){
		fprintf(opfile, "ifle Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	else if(op==NE_t){
		fprintf(opfile, "ifne Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	else if(op==GE_t){
		fprintf(opfile, "ifge Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	else if(op==GT_t){
		fprintf(opfile, "ifgt Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	else if(op==EQ_t){
		fprintf(opfile, "ifeq Ltrue_%d\n",loop_stack[pos_loop_stack]);
	}
	fprintf(opfile, "iconst_0\ngoto Lfalse_%d\n", loop_stack[pos_loop_stack]);
	fprintf(opfile, "Ltrue_%d:\niconst_1\nLfalse_%d:\n", loop_stack[pos_loop_stack], loop_stack[pos_loop_stack]);
	pos_loop_stack--;
}

void arithm(struct expr_sem *op1, OPERATOR op, struct expr_sem *op2){

	if(op1&&op2){
		if(((op1->pType->type==INTEGER_t || op1->pType->type==REAL_t) && (op2->pType->type==INTEGER_t || op2->pType->type==REAL_t))) {
			if(op1->pType->type==INTEGER_t && op2->pType->type==REAL_t){
				fprintf(opfile, "fstore 50\n");
				fprintf(opfile,"i2f\n");
				fprintf(opfile, "fload 50\n");
				op1->pType->type = REAL_t;
			}
			else if(op1->pType->type==REAL_t&&op2->pType->type==INTEGER_t){
				fprintf(opfile, "i2f\n");
			}
		}
	}

	if(op==ADD_t){
		if(op1->pType->type==INTEGER_t){
				fprintf(opfile, "iadd\n");
			}
			else if(op1->pType->type==REAL_t){
				fprintf(opfile, "fadd\n");
			}
	}
	else if(op==SUB_t){
		if(op1->pType->type==INTEGER_t){
				fprintf(opfile, "isub\n");
			}
			else if(op1->pType->type==REAL_t){
				fprintf(opfile, "fsub\n");
			}
	}
	else if(op==MUL_t){
		if(op1->pType->type==INTEGER_t){
				fprintf(opfile, "imul\n");
			}
			else if(op1->pType->type==REAL_t){
				fprintf(opfile, "fmul\n");
			}
	}
	else if(op==DIV_t){
		if(op1->pType->type==INTEGER_t){
				fprintf(opfile, "idiv\n");
			}
			else if(op1->pType->type==REAL_t){
				fprintf(opfile, "fdiv\n");
			}
	}
	else if(op==MOD_t){
		fprintf(opfile, "irem\n");
	}
}


