%{
package main

import (
	"fmt"
	"os"
)
%}

%union{
	id int
	name string
	varType uint
}
%start line
%token TYPE_INTEGER
%token TYPE_SEQUENCE
%token TYPE_OCTET_STRING
%token DIAPASONE
%token VARNAME
%token SIZE
%token OPER_ASSIGNMENT
%token COMMENT
%token LF
%token SKIP
%type <name> VARNAME
%type <varType> VARTYPE
%type <varType> TYPE_INTEGER
%type <varType> TYPE_SEQUENCE
%type <varType> TYPE_OCTET_STRING
%type <id> ASSIGNMENT
%type <id> DIAPASONE
%type <id> SIZE
%type <id> LF
%type <id> OPER_ASSIGNMENT

%%

line: COMMENT {fmt.Println("COMMENT")}
	| DIAPASONE {fmt.Println("DIAPASONE")}
	| VARNAME {fmt.Println("VARNAME")}	
	| ASSIGNMENT {fmt.Println("ASSIGNMENT")}
	| LF {fmt.Println("LF")}
	| SKIP {fmt.Println("SKIP")}
	| line COMMENT {fmt.Println("COMMENT")}
	| line DIAPASONE {fmt.Println("DIAPASONE")}
	| line VARNAME {fmt.Println("VARNAME")}	
	| line ASSIGNMENT {fmt.Println("ASSIGNMENT")}
	| line LF {fmt.Println("LF")}
	| line SKIP {fmt.Println("SKIP")}
;

ASSIGNMENT: VARNAME OPER_ASSIGNMENT VARTYPE {fmt.Println("--ASSIGNMENT--", $$, $1, $2, $3)}
;

VARTYPE: TYPE_OCTET_STRING {}
	| TYPE_INTEGER {}
	| TYPE_SEQUENCE VARNAME {}
	| TYPE_SEQUENCE VARTYPE {}
;

%%

func main() {
    f, _ := os.Open("1609dot2.asn")
    defer f.Close()
    l := NewLexer(f)
	yyParse(l)
}
