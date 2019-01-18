%{
package main

import (
    "os"
    "fmt"
)

type Lexer struct {
    source *os.File
    pos int64
    lastChar byte
    buf []byte
    readErr error 
}

func NewLexer(f *os.File) *Lexer {
    l := Lexer{
        source: f,
        buf: make([]byte, 1, 1),
    }
    l.getChar()

    return &l
}

func (l *Lexer) getChar() {
    _, l.readErr = l.source.Read(l.buf)
    l.pos++
    l.source.Seek(l.pos, 0)
    l.lastChar = l.buf[0]
}

func (l Lexer) Error(e string) {
    // log.Fatal(e)
    // fmt.Println(e)
}

func (l *Lexer) Lex(lval *yySymType) int {
%}
%yyc l.lastChar
%yyn {fmt.Printf(string(l.lastChar)); l.getChar(); if l.readErr != nil {return -1}}
%%
 //comments
\-\-[^\-\n\r]+\-\-  return COMMENT
\-\-[^\n\r]*$     return COMMENT
 //keywords
"INTEGER"       return TYPE_INTEGER
"SEQUENCE OF"   return TYPE_SEQUENCE
"OCTET STRING"  return TYPE_OCTET_STRING
"(SIZE("\d+"))" ;

 //operators
"::="           return OPER_ASSIGNMENT

 //others
\([0-9]+\.\.[0-9]+\)  ;
[\n\r]+         return LF
[ \t\n]+        ;
"DEFINITIONS"[^\n\r]+$    ;
"EXPORT"[^\n\r]+$        ;
"END"[^\n\r]+$           ;

 //names
[a-zA-Z][a-zA-Z0-9_]+   return VARNAME
.   
%%
    
    return int(l.lastChar)
}

// func main() {
//     f, _ := os.Open("1609dot2.asn")
//     defer f.Close()
//     l := NewLexer(f)
//     l.Lex()
//     fmt.Println(l.Tokens)
// }
