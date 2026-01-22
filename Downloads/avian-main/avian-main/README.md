# Avian
## Table of Contents

   [Overview](#overview)
   [Project Structure](#project-structure)
1. [Phase 1 Lexical Analyzer](#phase-1-lexical-analyzer)
     1.1 [Language Design](#language-design)
     1.2 [Language Philosophy](#language-philosophy)
     1.3 [Features](#features)
     1.4 [Installation and Setup](#installation-and-setup)
     1.5 [Building and Running the Scanner](#building-and-running-the-scanner)
     1.6 [Sample Program](#sample-program-avian_sampleavn)
     1.7 [Example Output](#example-output-tokenstxt)
     1.8 [Error Handling Examples](#error-handling-examples)
     1.9 [Documentation Includes](#documentation-includes)
2. [Phase 2 Syntax Analysis](#phase-2--syntax-analysis-parser)
     2.1 [Overview](#overview-1)
     2.2 [Role of Phase 2 in the Compiler](#role-of-phase-2-in-the-compiler)
     2.3 [Grammar Design](#grammar-design-cfg)
     2.4 [FIRST and FOLLOW Sets](#first-and-follow-sets-dragon-book-style)
     2.5 [Parse Tree Construction](#parse-tree-construction)
     2.6 [Parser Implementation](#parser-implementation)
     2.7 [Error Handling](#error-handling)
     2.8 [Building and Running the Parser](#building-and-running-the-parser)
     2.9 [Test Programs](#test-programs)
     2.10 [Phase 2 Outcome](#phase-2-outcome)
   
## Overview

This project implements a **lexical analyzer** (scanner) for a custom **Mini C++-like language** named **Avian**, developed using **Flex (Fast Lexical Analyzer Generator)**. The scanner forms the **first phase** of the compiler construction process. It reads source code written in the Avian language and breaks it down into **tokens** — identifiers, keywords, numbers, operators, strings, punctuations, and symbols — that can later be used by the parser and semantic analyzer.

This implementation focuses on correctness, originality, and realism according to the official rubric for Compiler Construction Project Phase 1.

---

## Project Structure

```
/avian-compiler/
│
├── scanner.l              # Flex source file (Phase 1 lexical analyzer)
├── parser.y               # Bison/YACC source file (Phase 2 syntax analyzer)
├── avian_sample.avn       # Valid Avian test program
├── avian_invalid.avn      # Invalid Avian program (syntax error test)
├── tokens.txt             # Token output from Phase 1
├── error.log              # Lexical error log (Phase 1)
├── README.md              # Complete documentation (Phase 1 + Phase 2)
│
├── build/
│   ├── lex.yy.c           # Generated C file from Flex
│   ├── y.tab.c            # Generated C file from Bison
│   ├── y.tab.h            # Token definitions shared by parser
│   └── avian_parser       # Final parser executable
│
└── docs/
    ├── regex_def.pdf      # Regex table + FA diagrams (Phase 1)
    ├── parse_tree.pdf     # Hand-drawn parse tree (Phase 2)
    ├── first_follow.pdf   # FIRST & FOLLOW sets (Phase 2)
    └── demo_video.mp4     # Execution + explanation video

```

## Language Design

### Keywords (15 total)

```
avn_if, avn_else, avn_for, avn_while, avn_break, avn_continue, avn_cin, avn_cout, avn_return, avn_print, avn_int, avn_float, avn_str, avn_main, avn_end
```

### Custom Operators (6 total)

| Operator | Description    |
| -------- | -------------- |
| `_+_`    | Addition       |
| `_-_`    | Subtraction    |
| `_*_`    | Multiplication |
| `_/ _`   | Division       |
| `_++_`   | Increment      |
| `_--_`   | Decrement      |

### Custom Punctuations (3 total)

| Symbol | Description                        |
| ------ | ---------------------------------- |
| `_,_`  | Comma separator                    |
| `;`   | Statement terminator               |
| `::`   | Section divider or scope separator |

---

## Language Philosophy

The word **Avian** literally means "related to birds" and just like that, the language draws its name and concept from birds.
Just as birds communicate in complex patterns and sounds that humans may not understand — yet they perfectly understand each other — *Avian* represents a similar philosophy in programming language design.

Although Avian is built on C++ syntax, its unique keywords and operators transform it into a distinct system of communication between the human and the compiler.

The goal is to demonstrate that:

* Language is not defined by the symbols themselves but by the **rules** that interpret them.
* A compiler can understand any structured language if its lexical and syntactical rules are clearly defined.

In short:

> Humans may not immediately understand the syntax of Avian,
> but the compiler can — just as birds understand one another.

---

## Features

### 1. Tokenization

The scanner identifies and classifies the following categories:

* **Keywords** (custom `avn_` prefixed words)
* **Identifiers**
* **Integers, floats, exponential numbers**
* **Operators (custom and default)**
* **Strings**
* **Punctuations**

### 2. Comment Handling

* **Single-line comments:** `// comment`
* **Multi-line comments:** `/* block comment */`

Comments are ignored by the scanner.

### 1. Error Handling

Unrecognized or invalid characters are reported in `error.log` with their respective line numbers.

**Example:**

```
Line 4: ERROR → @invalid
```

### 2. Line Tracking

Each token is printed with its **line number**, type, and value in the following format:

```
Line 3: KEYWORD              → avn_int
Line 3: IDENTIFIER           → a
Line 3: ASSIGN_OP            → =
Line 3: INTEGER              → 10
```

### 5. Realistic Token Coverage

The scanner includes both **custom Avian operators** and **default Mini C++ tokens** such as:

```
=, +, -, *, /, (, ), {, }, ,, ;, <, >, ==, !=
```

This ensures compatibility with real-world programming syntax.

---

## Installation and Setup

### Step 1 — Install Required Packages

```bash
sudo apt update
sudo apt install flex gcc
```

### Step 2 — Verify Installation

```bash
flex --version
gcc --version
```

Expected output includes version numbers for both Flex and GCC.

---

## Building and Running the Scanner

### Step 1 — Generate C Code from Flex

```bash
flex scanner.l
```

### Step 2 — Compile the Generated Code

```bash
gcc lex.yy.c -lfl -o avian_scanner
```

### Step 3 — Run the Scanner

To scan interactively:

```bash
./avian_scanner
```

To scan a file:

```bash
./avian_scanner < avian_sample.avn > tokens.txt 2> error.log
```

### Step 4 — View Results

* **tokens.txt** — recognized tokens with line numbers
* **error.log** — lexical errors and unclosed comment reports

---

## Sample Program (`avian_sample.avn`)

```
avn_func avn_int avn_main;'
avn_int a = 10;'
avn_int b = 5;'
avn_int sum;'
avn_int prod;'

avn_if (a _-_ b) {
    avn_print "Positive difference";'
}
avn_else {
    avn_print "Zero or negative";'
}

sum = a _+_ b;'
prod = a _*_ b;'
avn_print "Sum:" _,_ sum;'
avn_print "Product:" _,_ prod;'
avn_end;'
avn_return 0;'
```

---

## Example Output (`tokens.txt`)

```
Line 1: KEYWORD              → avn_func
Line 1: KEYWORD              → avn_int
Line 1: KEYWORD              → avn_main
Line 2: KEYWORD              → avn_int
Line 2: IDENTIFIER           → a
Line 2: ASSIGN_OP            → =
Line 2: INTEGER              → 10
Line 2: PUNC_SEMI_APOS       → ;'
Line 3: KEYWORD              → avn_int
Line 3: IDENTIFIER           → b
Line 3: ASSIGN_OP            → =
Line 3: INTEGER              → 5
Line 3: PUNC_SEMI_APOS       → ;'
...
Line 12: KEYWORD             → avn_end
Line 13: KEYWORD             → avn_return
Line 13: INTEGER             → 0
Line 13: PUNC_SEMI_APOS      → ;'
```

---

## Error Handling Examples

**Invalid Symbol**

```
avn_int $value;'
```

**Output:**

```
Line 1: ERROR → $
```

**Unclosed Comment**

```
/* missing end
avn_int x;'
```

**Output:**

```
Line 2: ERROR → unclosed comment
```

---

## Documentation Includes

### 1. Regex Definitions Table

Include a detailed table listing all regex patterns used to identify:

* Identifiers
* Numbers (integer, float, exponential)
* Keywords
* Operators
* Punctuations
* Strings

### 2. Finite Automata Diagrams

Provided FA diagrams for:

* **Identifiers**
* **Numbers (integers and floats)**

### 1. Keyword and Operator Explanation

All keywords in Avian share the `avn_` prefix to make them easily distinguishable from identifiers, simplify regex patterns, streamline FA design through a shared starting path, and maintain a consistent, readable, C++-like structure. It keeps every reserved word distinct, easy to detect, and ensures consistent token recognition across the language.

---

# Phase 2 — Syntax Analysis (Parser)

## Overview

Phase 2 extends the Avian compiler by implementing a **syntax analyzer (parser)** using **YACC / Bison**, following the principles of compiler design. While Phase 1 focused on breaking the source program into tokens, Phase 2 focuses on **verifying the grammatical structure** of those tokens using a **Context-Free Grammar (CFG)**.The parser ensures that programs written in the Avian language follow valid syntactic rules before moving to later compilation phases.

---

## Role of Phase 2 in the Compiler

Phase 2 performs **syntax analysis**, which means:

* Checking whether the sequence of tokens produced by the scanner is grammatically valid
* Ensuring correct statement structure
* Detecting and reporting syntax errors with line numbers
* Conceptually constructing a parse tree for valid programs

This phase does **not** perform semantic analysis or code generation.

---

## Grammar Design (CFG)

The Avian grammar is designed using **Dragon Book conventions**, with short non-terminals and clear structure.

### Start Symbol

```
P
```

### Grammar Rules

```
P  → B

B  → { SL }

SL → S SL | ε

S  → D | A | IF | WH | OUT

D  → avn_int id ;

A  → id = num ;

IF → avn_if ( num ) B
    | avn_if ( num ) B avn_else B

WH → avn_while ( num ) B

OUT → avn_print id ;
```

This grammar supports all mandatory constructs required by the Phase 2 rubric:

* Program structure
* Variable declaration
* Assignment
* Conditional statements
* Loop statements
* Output statements

---

## FIRST and FOLLOW Sets (Dragon Book Style)

### FIRST Sets

```
FIRST(S)  = { avn_int, id, avn_if, avn_while, avn_print }
FIRST(SL) = { avn_int, id, avn_if, avn_while, avn_print, ε }
```

### FOLLOW Sets

```
FOLLOW(P)  = { $ }
FOLLOW(SL) = { }, $ }
FOLLOW(S)  = { avn_int, id, avn_if, avn_while, avn_print, }, $ }
```

These sets are used during grammar analysis to ensure correct parsing behavior and error detection.

---

## Parse Tree Construction

For a valid Avian program fragment:

```
{
  avn_int a;
  a = 5;
  avn_if (1) { avn_print a; }
}
```

A fully expanded **parse tree** can be constructed based on the grammar rules, showing how the program derives from the start symbol `P`.

The parse tree is **documented manually** (hand-drawn), as required by the project rubric.
The parser itself does not print the parse tree during execution.

---

## Parser Implementation

The parser is implemented using **Bison**, and it is tightly integrated with the Phase 1 scanner.

### Key Characteristics

* Reuses **all tokens** defined in `scanner.l`
* Uses `%token` declarations to share tokens between scanner and parser
* Implements grammar rules exactly as defined in the CFG
* Reports syntax errors using `yyerror()`
* Prints a success message if parsing completes without errors

---

## Error Handling

The parser detects and reports syntax errors such as:

* Missing semicolons
* Missing parentheses
* Invalid statement structure

### Example Error Output

```
Syntax Error at line 4: expected ';' but found '}'
```

Each error message includes:

* Line number
* Nature of error
* Found token

---

## Building and Running the Parser

### Required Tools

* Flex
* Bison
* GCC

### Build Commands

```bash
flex scanner.l
bison -dy parser.y
gcc lex.yy.c y.tab.c -o avn_parser
```

### Run the Parser

```bash
./avn_parser < avian_sample.avn
```

### Successful Output

```
Syntax analysis successful
```

---

## Test Programs

### Valid Program (valid.avn)

```
{
  avn_int a = 10;
  avn_int b = 5;
  avn_int sum;
  avn_int prod;
  
  sum = a _+_ b;
  prod = a _*_ b;
  
  avn_print sum;
  avn_print prod;
  
  avn_if (a _-_ b) {
    avn_print a;
  }
  avn_else {
    avn_print b;
  }
  
  avn_while (10) {
    avn_int x = 5 _+_ 3;
    avn_print x;
  }
}
```

Expected Output:

```
Line 2: KEYWORD              → avn_int
Line 2: IDENTIFIER           → a
Line 2: ASSIGN_OP            → =
Line 2: INTEGER              → 10
Line 2: SEMICOLON            → ;
Line 3: KEYWORD              → avn_int
Line 3: IDENTIFIER           → b
Line 3: ASSIGN_OP            → =
Line 3: INTEGER              → 5
Line 3: SEMICOLON            → ;
Line 4: KEYWORD              → avn_int
Line 4: IDENTIFIER           → sum
Line 4: SEMICOLON            → ;
Line 5: KEYWORD              → avn_int
Line 5: IDENTIFIER           → prod
Line 5: SEMICOLON            → ;
Line 7: IDENTIFIER           → sum
Line 7: ASSIGN_OP            → =
Line 7: IDENTIFIER           → a
Line 7: OP_ADD               → _+_
Line 7: IDENTIFIER           → b
Line 7: SEMICOLON            → ;
Line 8: IDENTIFIER           → prod
Line 8: ASSIGN_OP            → =
Line 8: IDENTIFIER           → a
Line 8: OP_MUL               → _*_
Line 8: IDENTIFIER           → b
Line 8: SEMICOLON            → ;
Line 10: KEYWORD             → avn_print
Line 10: IDENTIFIER          → sum
Line 10: SEMICOLON           → ;
Line 11: KEYWORD             → avn_print
Line 11: IDENTIFIER          → prod
Line 11: SEMICOLON           → ;
Line 13: KEYWORD             → avn_if
Line 13: LPAREN              → (
Line 13: IDENTIFIER          → a
Line 13: OP_SUB              → _-_
Line 13: IDENTIFIER          → b
Line 13: RPAREN              → )
Line 13: LBRACE              → {
Line 14: KEYWORD             → avn_print
Line 14: IDENTIFIER          → a
Line 14: SEMICOLON           → ;
Line 15: RBRACE              → }
Line 16: KEYWORD             → avn_else
Line 16: LBRACE              → {
Line 17: KEYWORD             → avn_print
Line 17: IDENTIFIER          → b
Line 17: SEMICOLON           → ;
Line 18: RBRACE              → }
Line 20: KEYWORD             → avn_while
Line 20: LPAREN              → (
Line 20: INTEGER             → 10
Line 20: RPAREN              → )
Line 20: LBRACE              → {
Line 21: KEYWORD             → avn_int
Line 21: IDENTIFIER          → x
Line 21: ASSIGN_OP           → =
Line 21: INTEGER             → 5
Line 21: OP_ADD              → _+_
Line 21: INTEGER             → 3
Line 21: SEMICOLON           → ;
Line 22: KEYWORD             → avn_print
Line 22: IDENTIFIER          → x
Line 22: SEMICOLON           → ;
Line 23: RBRACE              → }
Line 24: RBRACE              → }
Syntax analysis successful
```

### Invalid Program (invalid.avn)

```
{
  avn_int a = 10;
  avn_int b;
  b = a _+_ 5
  avn_print b;
}
```

Expected Output:

```
Line 2: KEYWORD              → avn_int
Line 2: IDENTIFIER           → a
Line 2: ASSIGN_OP            → =
Line 2: INTEGER              → 10
Line 2: SEMICOLON            → ;
Line 3: KEYWORD              → avn_int
Line 3: IDENTIFIER           → b
Line 3: SEMICOLON            → ;
Line 4: IDENTIFIER           → b
Line 4: ASSIGN_OP            → =
Line 4: IDENTIFIER           → a
Line 4: OP_ADD               → _+_
Line 4: INTEGER              → 5
Line 5: KEYWORD              → avn_print
Syntax Error at line 5: syntax error, found 'avn_print'
```

The error occurs because line 4 is missing a semicolon after the assignment statement.

---

## Phase 2 Outcome

By the end of Phase 2, the Avian compiler is capable of:

* Validating complete Avian programs syntactically
* Detecting grammar violations
* Preparing the code structure for semantic analysis

This phase demonstrates the practical application of **CFGs, FIRST/FOLLOW sets, and parsing theory**.
