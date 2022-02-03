module lambda.parse;

import lambda.lexer, lambda.expr, lambda.error;


class Interpret {
  Expr betaReduction(Expr expr) {
    if(auto var = cast(Var) expr) {
      return var;
    } else if (auto app = cast(App) expr) {
      if(auto lambda = cast(Lambda) app.left) {
        return this.subs(lambda.param, app.right, lambda.expr);
      }

      return new App(this.betaReduction(app.left), this.betaReduction(app.right));
    } else if (auto lam = cast(Lambda) expr) {
      return new Lambda(lam.param, this.betaReduction(lam.expr));
    }

    throw new Error("jklasjdklasjk");
  }

  Expr subs(string from, Expr to, Expr expr) {
    if(auto var = cast(Var) expr) {
      if(var.name == from) {
        return to;
      }

      return var;
    } else if(auto lam = cast(Lambda) expr) {
      if(lam.param == from) {
        return lam;
      }

      return new Lambda(lam.param, this.subs(from, to, lam.expr));
    } else if(auto app = cast(App) expr) {
      return new App(subs(from, to, app.left), subs(from, to, app.right));
    }

    throw new Error("jklasjdklasjk");
  }
}

class Expr  {

}

class Var : Expr {
  string name;
  this(string name) {
    this.name = name;
  }
}

class App : Expr {
  Expr left;
  Expr right;

  this(Expr left, Expr right) {
    this.left = left;
    this.right = right;
  }
}

class Lambda : Expr {
  string param;
  Expr expr;

  this(string param, Expr expr) {
    this.param = param;
    this.expr = expr;
  }
} 


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