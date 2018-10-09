extern int linenum;
extern FILE* opfile;
extern int scope;
extern struct SymTable *symbolTable;	// main symbol table
extern char fileName[256];
extern struct iList iList;


extern int pos_stack;
extern int stack[100];
void pgstart(char* name);
void gglobalv(char* name, struct PType* type);
void funcmethod(char* name, char* para, char* fu);
void funcdec(char* id, struct param_sem* paras,struct PType* r);
void storeexpr(struct expr_sem* expr, struct expr_sem* rhs);
void printfunc(struct expr_sem* ex);
void readfunc(struct expr_sem* expr);
void forloop(char* id, int sta, int end);
void forend(char* id, int sta, int end);
void constload(struct ConstAttr* constl);
void funccall(char* id);
void funcend(struct PType* r);
void boolean( struct expr_sem *op1, OPERATOR op, struct expr_sem *op2);
void relat( struct expr_sem *op1, OPERATOR op, struct expr_sem *op2);
void arithm(struct expr_sem *op1, OPERATOR op, struct expr_sem *op2);

