module lambda.parse;

import lambda.lexer, lambda.expr, lambda.error, lambda.syntax;


class Parser {
  Lexer lexer;
  int pos;

  this(Lexer lex) {
    this.pos = 0;
    this.lexer = lex;
  }

  Token advance() {
    return this.lexer.advanceToken();
  }

  Token lookUp() {
    return this.lexer.lookUp();
  }

  Token eat(TokenType id) {
    immutable auto actual = this.advance();
    if(actual.type == id) {
      return actual;
    }

    throw new UnexpectedError(id, actual.type, actual.pos.col, actual.pos.line, "parse.d");
  }

  Lambda lambda() {
    this.eat(TokenType.LAMBDA);
    auto name = this.eat(TokenType.VAR);
    this.eat(TokenType.DOT);
    auto app = this.app();

    return new Lambda(name.value, app);
  }

  Expr app() {
    auto left = this.expr();

    while(this.lookUp().type != TokenType.RPAR && this.lookUp().type != TokenType.EOF) {
      auto right = this.expr();
      
      left = new App(left, right);
    }


    return left;
  }

  Expr expr() {
    auto token = this.lookUp();
    if(token.type == TokenType.VAR) {
      auto name = this.eat(TokenType.VAR);
      return new Var(name.value);
    } else if(token.type == TokenType.LAMBDA) {
      return this.lambda();
    } else if(token.type == TokenType.LPAR) {
      this.eat(TokenType.LPAR);
      auto app = this.app();
      this.eat(TokenType.RPAR);

      return app;
    } else {
      throw new UnexpectedError(TokenType.VAR, token.type, token.pos.col, token.pos.line, "parse.d");
    }
  }
}