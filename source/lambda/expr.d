module lambda.expr;

import lambda.lexer;

struct Token {
  string type;
  string value;
  RelPos pos;
}

enum TokenType {
  LAMBDA = "\\",
  APP = "app",
  VAR = "var",
  EOF = "eof",
  NUMBER = "number",
  RPAR = ")",
  LPAR = "(",
  DOT = "."
}