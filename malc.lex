/*Author     : Alex Zhang (cgzhangwei@gmail.com)  */
/*Date       : Jun.05.2014                        */
/*Description: Import from VeSPA project.         */
/* LEX source for malc.c						*/

/* start of definitions							*/

letter		[a-zA-Z]
digit		[0-9]
hex		[a-fA-F]


/* start of rules							*/

/* These are all of the mnemonic op-codes recognized by the assembler.
   Note that the input file can be either upper or lower-case, or a mix
   of both.
*/

%%

add|ADD		{yylval = NONE;		return(ADD);	}
addi|ADDI	{yylval = NONE;		return(ADDI);	}
and|AND		{yylval = NONE;		return(AND);	}
andi|ANDI	{yylval = NONE;		return(ANDI);	}
bra|BRA		{yylval = BRA_COND;	return(BRANCH);	}
bnv|BNV		{yylval = BNV_COND;	return(BRANCH);	}
bcc|BCC		{yylval = BCC_COND;	return(BRANCH);	}
bcs|BCS		{yylval = BCS_COND;	return(BRANCH);	}
bvc|BVC		{yylval = BVC_COND;	return(BRANCH);	}
bvs|BVS		{yylval = BVS_COND;	return(BRANCH);	}
beq|BEQ		{yylval = NONE;  	return(BEQ);	}
bne|BNE		{yylval = BNE_COND;	return(BRANCH);	}
bge|BGE		{yylval = BGE_COND;	return(BRANCH);	}
blt|BLT		{yylval = BLT_COND;	return(BRANCH);	}
bgt|BGT		{yylval = BGT_COND;	return(BRANCH);	}
ble|BLE		{yylval = BLE_COND;	return(BRANCH);	}
bpl|BPL		{yylval = BPL_COND;	return(BRANCH);	}
bmi|BMI		{yylval = BMI_COND;	return(BRANCH);	}
cmp|CMP		{yylval = NONE;		return(CMP);	}
hlt|HLT		{yylval = NONE;		return(HLT);	}
jmp|JMP		{yylval = NONE;		return(JMP);	}
jmpl|JMPL	{yylval = NONE;		return(JMPL);	}
lw|LW           {yylval = NONE;         return(LW);     }
ld|LD		{yylval = NONE;		return(LD);	}
ldi|LDI		{yylval = NONE;		return(LDI);	}
ldx|LDX		{yylval = NONE;		return(LDX);	}
mov|MOV		{yylval = NONE;		return(MOV);	}
nop|NOP		{yylval = NONE;		return(NOP);	}
nor|NOR		{yylval = NONE;		return(NOR);	}
not|NOT		{yylval = NONE;		return(NOT);	}
or|OR		{yylval = NONE;		return(OR);	}
ori|ORI		{yylval = NONE;		return(ORI);	}
xor|XOR         {yylval = NONE;         return(XOR);    }
st|ST		{yylval = NONE;		return(ST);	}
stx|STX		{yylval = NONE;		return(STX);	}
sll|SLL		{yylval = NONE;		return(SLL);	}
srl|SRL		{yylval = NONE;		return(SRL);	}
slt|SLT		{yylval = NONE;		return(SLT);	}
sub|SUB		{yylval = NONE;		return(SUB);	}
sw|SW		{yylval = NONE;		return(SW);	}

$zero           {
                yylval = add_symbol(yytext);
                sym_table[yylval].value = 0;
                return (REG_NUM);
                }

$v{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$v%d",&sym_table[yylval].value);
                process_reg('v', yylval);
		return(REG_NUM);
                }

$V{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$V%d",&sym_table[yylval].value);
                process_reg('v', yylval);
		return(REG_NUM);
                }

$t{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$t%d",&sym_table[yylval].value);
                process_reg('t', yylval);
		return(REG_NUM);
                }

$T{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$T%d",&sym_table[yylval].value);
                process_reg('t', yylval);
		return(REG_NUM);
                }

$f{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$f%d",&sym_table[yylval].value);
                process_reg('f', yylval);
		return(REG_NUM);
                }

$F{digit}+      {
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$F%d",&sym_table[yylval].value);
                process_reg('f', yylval);
		return(REG_NUM);
                }

$s{digit}+	{	/* register, e.g. $s0				*/
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$s%d",&sym_table[yylval].value);
                process_reg('s', yylval);
		return(REG_NUM);
		}

$S{digit}+	{	/* register, e.g. $S0				*/
		yylval = add_symbol(yytext);
		/* extract register number from string			*/
		sscanf(sym_table[yylval].name,"$S%d",&sym_table[yylval].value);
                process_reg('s', yylval);
		return(REG_NUM);
		}

(_|{letter})({letter}|{digit}|_|"."|"$")*	{
	yylval = add_symbol(yytext);
	return(IDENTIFIER);
	}

0x({digit}|{hex})+	{ /* hex constants, e.g. 0x1A			*/
		yylval = add_symbol(yytext);
		/* convert string to actual value			*/
		sscanf(yytext,"0x%x",&sym_table[yylval].value);
		return(NUMBER);
		}

{digit}+	{
		yylval = add_symbol(yytext);
		/* convert string to actual value			*/
		sscanf(yytext,"%d",&sym_table[yylval].value);
		return(NUMBER);
		}

".word"|".WORD"	{yylval = NONE;		return(DOT_WORD);	}

".byte"|".BYTE"	{yylval = NONE;		return(DOT_BYTE);	}

".alloc"|".ALLOC" {yylval = NONE;	return(DOT_ALLOC);	}

".org"|".ORG"	{yylval = NONE;		return(DOT_ORG);	}

".equ"|".EQU"	{yylval = NONE;		return(DOT_EQU);	}

","		{yylval = NONE;		return(',');	}

"#"		{yylval = NONE;		return('#');	}

"+"		{yylval = NONE;		return('+');	}

"-"		{yylval = NONE;		return('-');	}

":"		{yylval = NONE;		return(':');	}

"("		{yylval = NONE;		return('(');	}

")"		{yylval = NONE;		return(')');	}

"\n"		{
		curr_line++;		/* looking at next source line	*/
		}

[ \t]*		;		/* ignore any white space		*/

(";"|"//")(.)*	;		/* ; or // start comments		*/



%%
/* start of programs section						*/
//Add the offset according to https://github.com/alexzhang007/MipsCpu/wiki/Figure2.18
void process_reg(char type, int index){
    switch (type) {
        case 'v' : 
                  if (sym_table[index].value <2) {
                      sym_table[index].value+= 2 ;
                  }else {
                      sprintf(err_msg,"no such register $v%d",sym_table[index].value );
                      err_exit(REG_OFLW,err_msg);
                  }
                  break;
        case 's' : 
                  if (sym_table[index].value <8) {
                      sym_table[index].value+= 16 ;
                  }else {
                      sprintf(err_msg,"no such register $s%d",sym_table[index].value );
                      err_exit(REG_OFLW,err_msg);
                  }
                  break;
        case 'a' :
                  if (sym_table[index].value <4) {
                      sym_table[index].value  += 4 ;
                  }else {
                      sprintf(err_msg,"no such register $a%d",sym_table[index].value );
                      err_exit(REG_OFLW,err_msg);
                  }
                  break;
        case 't' :
                  if (sym_table[index].value <8) {
                      sym_table[index].value  += 8 ;
                  }else if (sym_table[index].value < 10) {
                      sym_table[index].value  += 16 ;
                  }else {
                      sprintf(err_msg,"no such register $t%d",sym_table[index].value );
                      err_exit(REG_OFLW,err_msg);
                  }    
                  break;
        case 'f' : 
                  if (sym_table[index].value <32) {
                      sym_table[index].value  += 32 ;
                  } else {
                      sprintf(err_msg,"no such register $f%d",sym_table[index].value );
                      err_exit(REG_OFLW,err_msg);
                  }
                  break;

    }

}





