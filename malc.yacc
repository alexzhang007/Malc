/*Author     : Alex Zhang (cgzhangwei@gmail.com)  */
/*Date       : Jun.05.2014                        */
/*Description: Import from VeSPA project.         */
/* YACC grammar rules for malc						*/

%{
#include <stdio.h>
#include "gvars.h"		/* declaration of global variables	*/

void  process_reg(char, int);

int	temp1;		/* temp used to add some implicit ops		*/
int	temp2;		/* temp used to add some implicit ops		*/
char	temp_str[80];	/* temp string used for conversions		*/
int	j;		/* loop counter					*/
int	lc = 0;		/* location counter--# bytes for this instr	*/

%}

/* start of definitions							*/

%start	stmt_list

/* tokens and values returned by lexical analyzer			*/

%token	ADD			/* yylval = NONE			*/
%token	ADDI			/* yylval = NONE			*/
%token	AND			/* yylval = NONE			*/
%token	ANDI			/* yylval = NONE			*/
%token	BRANCH			/* yylval = branch condition		*/
%token	BEQ			/* yylval = branch condition		*/
%token	BNE			/* yylval = branch condition		*/
%token	CMP			/* yylval = NONE			*/
%token	HLT			/* yylval = NONE			*/
%token	JMP			/* yylval = NONE			*/
%token	JMPL			/* yylval = NONE			*/
%token	LW			/* yylval = NONE			*/
%token	LD			/* yylval = NONE			*/
%token	LDI			/* yylval = NONE			*/
%token	LDX			/* yylval = NONE			*/
%token	MOV			/* yylval = NONE			*/
%token	NOP			/* yylval = NONE			*/
%token	NOR			/* yylval = NONE			*/
%token	NOT			/* yylval = NONE			*/
%token	OR			/* yylval = NONE			*/
%token	ORI			/* yylval = NONE			*/
%token  XOR                     /* yylval = NONE                        */
%token	SLL			/* yylval = NONE			*/
%token	SRL			/* yylval = NONE			*/
%token	SLT			/* yylval = NONE			*/
%token	ST			/* yylval = NONE			*/
%token	STX			/* yylval = NONE			*/
%token	SUB			/* yylval = NONE			*/
%token	SW			/* yylval = NONE			*/
%token	IDENTIFIER		/* yylval = pointer into symbol table	*/
%token	NUMBER			/* yylval = pointer into symbol table	*/
%token	REG_NUM			/* yylval = pointer into symbol table	*/
%token	DOT_WORD		/* yylval = NONE			*/
%token	DOT_BYTE		/* yylval = NONE			*/
%token	DOT_ALLOC		/* yylval = NONE			*/
%token	DOT_ORG			/* yylval = NONE			*/
%token	DOT_EQU			/* yylval = NONE			*/


/* start of rules section						*/
%%

stmt_list :	stmt
	|	stmt_list stmt
	;

stmt	:	ADD	reg ',' reg ',' reg
			{
			add_stmt(ADD_OP,ADD_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	ADDI	reg ',' reg ',' '#' expr
			{
			add_stmt(ADDI_OP,ADDI_CODE,$4,$2,$7,IMMEDIATE,WORD_SIZE);
			}
	|	AND	reg ',' reg ',' reg
			{
			add_stmt(AND_OP,AND_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	ANDI	reg ',' reg ',' '#' expr
			{
			add_stmt(ANDI_OP,ANDI_CODE,$4,$2,$7,IMMEDIATE,WORD_SIZE);
			}
	|	BRANCH	IDENTIFIER
			{
			add_stmt(BRANCH_OP,BXX_CODE,$2,zero_ptr,zero_ptr,$1,WORD_SIZE);
			}
	|	BEQ     reg ',' reg ','	IDENTIFIER
			{
			add_stmt(BEQ_OP,BEQ_CODE,$2,$4,$6,IMMEDIATE,WORD_SIZE);
			}
	|	CMP	reg ',' reg
			{
			add_stmt(CMP_OP,CMP_CODE,$2,$4,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	CMP	reg ',' '#' expr
			{
			add_stmt(CMP_OP,CMP_CODE,$2,$5,zero_ptr,IMMEDIATE,WORD_SIZE);
			}
	|	HLT
			{
			add_stmt(HLT_OP,HLT_CODE,zero_ptr,zero_ptr,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	JMP	reg
			{
			add_stmt(JMP_OP,JMP_CODE,$2,zero_ptr,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	JMP	IDENTIFIER
			{
			add_stmt(JMP_OP,JMP_CODE,$2,zero_ptr,zero_ptr,IMMEDIATE,WORD_SIZE);
			}
	|	JMPL	reg ',' reg
			{
			add_stmt(JMPL_OP,JMP_CODE,$2,$4,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	JMPL	reg ',' reg ',' '#' expr
			{
			add_stmt(JMPL_OP,JMP_CODE,$2,$4,$7,IMMEDIATE,WORD_SIZE);
			}
        |       LW      reg ',' expr '(' reg ')'
                        {
			add_stmt(LW_OP,LW_CODE,$6,$2,$4,REG_TYPE,WORD_SIZE);
                        }
	|	LD	reg ',' IDENTIFIER
			{
			add_stmt(LD_OP,LD_CODE,$2,$4,zero_ptr,IMMEDIATE,WORD_SIZE);
			}
	|	LDI	reg ',' '#' expr
			{
			add_stmt(LDI_OP,LDI_CODE,$2,$5,zero_ptr,IMMEDIATE,WORD_SIZE);
			}
	|	LDX	reg ',' reg
			{
			add_stmt(LDX_OP,LDX_CODE,$2,$4,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	LDX	reg ',' reg ',' '#' expr
			{
			add_stmt(LDX_OP,LDX_CODE,$2,$4,$7,IMMEDIATE,WORD_SIZE);
			}
	|	MOV	reg ',' reg
			{
			add_stmt(MOV_OP,ADD_CODE,$2,$4,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	NOP
			{
			add_stmt(NOP_OP,NOP_CODE,zero_ptr,zero_ptr,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	NOR	reg ',' reg ',' reg
			{
			add_stmt(NOR_OP,NOR_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	NOT	reg ',' reg
			{
			add_stmt(NOT_OP,NOT_CODE,$2,$4,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	OR	reg ',' reg ',' reg
			{
			add_stmt(OR_OP,OR_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	ORI	reg ',' reg ',' expr
			{
			add_stmt(OR_OP,OR_CODE,$4,$2,$6,IMMEDIATE,WORD_SIZE);
			}
	|	SLT	reg ',' reg ',' reg
			{
			add_stmt(SLT_OP,SLT_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	SLL	reg ',' reg ',' expr
			{
			add_stmt(SLL_OP,SLL_CODE,zero_ptr,$4,$2,IMMEDIATE,WORD_SIZE,$6);
			}
	|	SRL	reg ',' reg ',' expr
			{
			add_stmt(SRL_OP,SRL_CODE,zero_ptr,$4,$2,IMMEDIATE,WORD_SIZE,$6);
			}
        |	ST	IDENTIFIER ',' reg
			{
			add_stmt(ST_OP,ST_CODE,$2,$4,zero_ptr,IMMEDIATE,WORD_SIZE);
			}
	|	STX	reg ',' reg
			{
			add_stmt(STX_OP,STX_CODE,$4,$2,zero_ptr,REG_TYPE,WORD_SIZE);
			}
	|	STX	reg ',' '#' expr ',' reg
			{
			add_stmt(STX_OP,STX_CODE,$7,$2,$5,IMMEDIATE,WORD_SIZE);
			}
	|	SUB	reg ',' reg ',' reg
			{
			add_stmt(SUB_OP,SUB_CODE,$4,$6,$2,REG_TYPE,WORD_SIZE);
			}
	|	SUB	reg ',' reg ',' '#' expr
			{
			add_stmt(SUB_OP,SUB_CODE,$2,$4,$7,IMMEDIATE,WORD_SIZE);
			}
        |       SW      reg ',' expr '(' reg ')'
                        {
			add_stmt(SW_OP,SW_CODE,$6,$2,$4,REG_TYPE,WORD_SIZE);
                        }
	|	DOT_ALLOC expr
			{
			add_stmt(DOT_ALLOC_OP,0,$2,zero_ptr,zero_ptr,PSEUDO_OP,sym_table[$2].value);
			}
	|	DOT_WORD expr
			{
			add_stmt(DOT_WORD_OP,0,$2,zero_ptr,zero_ptr,PSEUDO_OP,4);
			}
	|	DOT_BYTE expr
			{
			add_stmt(DOT_BYTE_OP,0,$2,zero_ptr,zero_ptr,PSEUDO_OP,1);
			}
	|	DOT_ORG expr
			{
			add_stmt(DOT_ORG_OP,0,$2,zero_ptr,zero_ptr,PSEUDO_OP,0);
			}
	|	label
			{
			$$ = $1;
			}
	|	equ_stmt
			{
			$$ = $1;
			}
	|	error
			{
			sprintf(err_msg,"Syntax error near line #%d\n",curr_line);
			err_exit(err_msg,PARSE_ABORT);
			}
        |	XOR	reg ',' reg ',' reg
			{
			add_stmt(XOR_OP,XOR_CODE,$2,$4,$6,REG_TYPE,WORD_SIZE);
			}
	|	XOR	reg ',' reg ',' '#' expr
			{
			add_stmt(XOR_OP,XOR_CODE,$2,$4,$7,IMMEDIATE,WORD_SIZE);
			}
	;

equ_stmt:	IDENTIFIER DOT_EQU NUMBER
			{
			/* equate a value with a label			*/
			sym_table[$1].value = sym_table[$3].value;
			$$ = $1;
			}
	;

label	:	IDENTIFIER ':'
			{
			/* The value of a label is simply the current
			   value of the location counter.		*/
			sym_table[$1].value = lc;
			$$ = $1;
			}
	;

value	:	NUMBER
			{
			$$ = $1;
			}
	|	equ_stmt
			{
			$$ = $1;
			}
	|	label
			{
			$$ = $1;
			}
	|	IDENTIFIER
			{
			$$ = $1;
			}
	;

/* This provides a very simple form of expression evaluation at
assembly time.  Note, however, that all values (e.g. labels) must
be defined before they can be used in an expression.  This simple
approach does not allow foward references in expression evaluations! */

expr	:	value
			{
			$$ = $1;
			}
	|	'+' value
			{
			$$ = $2;
			}
	|	'-' value
			{
			temp1 = 0 - sym_table[$2].value;
			sprintf(temp_str,"%d",temp1);
			temp2 = add_symbol(temp_str);
			sym_table[temp2].value = temp1;
			$$ = temp2;
			}
	|	expr '+' value
			{
			temp1 = sym_table[$1].value + sym_table[$3].value;
			sprintf(temp_str,"%d",temp1);
			temp2 = add_symbol(temp_str);
			sym_table[temp2].value = temp1;
			$$ = temp2;
			}
	|	expr '-' value
			{
			temp1 = sym_table[$1].value - sym_table[$3].value;
			sprintf(temp_str,"%d",temp1);
			temp2 = add_symbol(temp_str);
			sym_table[temp2].value = temp1;
			$$ = temp2;
			}
	;


reg	:	REG_NUM
			{
                        $$ = $1;	
                        }
	;



/* start of programs section						*/
%%

/* add opcode, operands, etc. to current statement			*/
add_stmt(operation,code,o1,o2,o3,misc,n, shamt)
int	operation;	/* type of operation, e.g. ADD, JMPL		*/
int	code;	/* the opcode that will appear in the object file	*/
int	o1;	/* pointer into sym_table[] for operand 1		*/
int	o2;	/* pointer into sym_table[] for operand 2		*/
int	o3;	/* pointer into sym_table[] for operand 3		*/
int	misc;	/* misc info for this instruction, can also used to functor for RT format instruction*/
int	n;	/* number of bytes for this instr			*/
int     shamt;  /* shift instruction*/
{
	stmt[curr_stmt].op_type = operation;
	stmt[curr_stmt].op_code = code;
	stmt[curr_stmt].op1 = o1;   //Rs[25:21]
	stmt[curr_stmt].op2 = o2;   //Rt[20:16]
	stmt[curr_stmt].op3 = o3;   //Rd[15:11]
	stmt[curr_stmt].misc = misc;
        stmt[curr_stmt].shamt = shamt;
	stmt[curr_stmt].line_num = curr_line;

	/* update lc by appropriate number of bytes, or jam it to the
	   value specified in the .org statement			*/
	if (operation == DOT_ORG_OP)
		lc = sym_table[o1].value;
	else	lc += n;

	curr_stmt++;
	if (curr_stmt >= MAX_ISTMT)
		err_exit("Too many input statements",STMT_OFLW);
}





#include "lex.yy.c"		/* source for lexical analyzer		*/





