/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CHRLIT = 258,
    ID = 259,
    REALLIT = 260,
    INTLIT = 261,
    COMMA = 262,
    ASSIGN = 263,
    OR = 264,
    XOR = 265,
    AND = 266,
    BITWISEOR = 267,
    BITWISEXOR = 268,
    BITWISEAND = 269,
    EQ = 270,
    NE = 271,
    LT = 272,
    LE = 273,
    GT = 274,
    GE = 275,
    PLUS = 276,
    MINUS = 277,
    MUL = 278,
    DIV = 279,
    MOD = 280,
    NOT = 281,
    LPAR = 282,
    RPAR = 283,
    ELSE = 284,
    CHAR = 285,
    WHILE = 286,
    INT = 287,
    IF = 288,
    SHORT = 289,
    DOUBLE = 290,
    RETURN = 291,
    VOID = 292,
    LBRACE = 293,
    RBRACE = 294,
    SEMI = 295,
    RESERVED = 296
  };
#endif
/* Tokens.  */
#define CHRLIT 258
#define ID 259
#define REALLIT 260
#define INTLIT 261
#define COMMA 262
#define ASSIGN 263
#define OR 264
#define XOR 265
#define AND 266
#define BITWISEOR 267
#define BITWISEXOR 268
#define BITWISEAND 269
#define EQ 270
#define NE 271
#define LT 272
#define LE 273
#define GT 274
#define GE 275
#define PLUS 276
#define MINUS 277
#define MUL 278
#define DIV 279
#define MOD 280
#define NOT 281
#define LPAR 282
#define RPAR 283
#define ELSE 284
#define CHAR 285
#define WHILE 286
#define INT 287
#define IF 288
#define SHORT 289
#define DOUBLE 290
#define RETURN 291
#define VOID 292
#define LBRACE 293
#define RBRACE 294
#define SEMI 295
#define RESERVED 296

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 24 "uccompiler.y" /* yacc.c:1909  */

    char *s;
    struct node* node;

#line 141 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
