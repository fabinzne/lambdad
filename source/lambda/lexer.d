module lambda.lexer;

import std.conv, std.array;

import lambda.expr, lambda.validator, lambda.error;

struct RelPos {
  int line;
  int col;
}

class Lexer {
  string input;
  RelPos relPos;
  ulong pos;
  Token current;
  Token next;

  this(string input) {
    this.input = input;
    this.relPos.line = 1;
    this.relPos.col = 1;
    this.pos = 0;
    Token c = {
      type: TokenType.EOF,
      value: "",
      pos: this.relPos,
    };
    this.current = c;
    this.next = this.nextToken();
  }


  Token lookUp() {
    return this.next;
  }

  Token advanceToken() {
    this.current = this.next;
    this.next = this.nextToken();

    return this.current;
  }

  private Token nextToken() {

    if(this.input.length == this.pos) {
      Token ret = {
        type: TokenType.EOF,
        value: "EOF",
        pos: this.relPos
      };

      return ret;
    }

    if(isUseless(this.input[this.pos])) {
      while(this.pos != this.input.length && isUseless(this.input[this.pos])) {
        if(this.input[this.pos] == '\n') {
          this.relPos.line += 1;
        } 

        this.pos += 1;
      }

      return this.nextToken();
    }

    switch (this.input[this.pos]) {
      case '\\':
        this.pos += 1;
        this.relPos.col += 1;
        Token ret = {
          type: TokenType.LAMBDA,
          pos: this.relPos,
          value: "\\"
        };

        return ret;
      case '.':
        this.pos += 1;
        this.relPos.col += 1;
        Token ret = {
          type: TokenType.DOT,
          pos: this.relPos,
          value: "."
        };

        return ret;
      case '(':
        this.pos += 1;
        this.relPos.col += 1;
        Token ret = {
          type: TokenType.LPAR,
          pos: this.relPos,
          value: "("
        };

        return ret;
      case ')':
        this.pos += 1;
        this.relPos.col += 1;
        Token ret = {
          type: TokenType.RPAR,
          pos: this.relPos,
          value: ")"
        };

        return ret;
      default:
        break;
    }

    // if(isDigit(this.input[this.pos])) {
    //   auto start = this.pos;
    //   while(this.pos != this.input.length && isDigit(this.input[this.pos])) {
    //     this.pos += 1;
    //   }

    //   Token ret = {
    //     type: TokenType.NUMBER,
    //     value: this.input[start .. this.pos],
    //     pos: this.relPos,
    //   };

    //   return ret;
    // }


    if(isValidStart(this.input[this.pos])) {
      const start = this.pos;

      while(this.pos != this.input.length && isValid(this.input[this.pos])) {
        this.pos += 1;
      }

      Token ret = {
        type: TokenType.VAR,
        value: this.input[start .. this.pos],
        pos: this.relPos,
      };

      return ret;
    }

    throw new UnrecognizeError(to!string(this.input[this.pos]), this.relPos.col, this.relPos.line, "lexer.d");
  }

  private string getValue() {
    string ret;

    while(this.input[this.pos] != '.') {
      this.pos += 1;
      if(!isUseless(this.input[this.pos])){
        ret = ret ~ to!string(this.input[this.pos]);
      }
    }

    return ret;
  } 
}