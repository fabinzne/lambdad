module lambda.syntax;
import std.stdio;

interface Expr  {
  Expr betaReduction();
  Expr subs(string, Expr);
  string show();
}

class Var : Expr {
  string name;
  this(string name) {
    this.name = name;
  }

  Var betaReduction() {
    return this;
  }

  Expr subs(string from, Expr to) {
    if(this.name == from) {
      return to;
    }

    return this;
  }

  string show() {
    return this.name;
  }
}

class App : Expr {
  Expr left;
  Expr right;

  this(Expr left, Expr right) {
    this.left = left;
    this.right = right;
  }

  Expr betaReduction() {
    writeln("=> " ~ this.left.show() ~ " " ~ this.right.show());

    if(auto lam = cast(Lambda) this.left) {
      return lam.expr.subs(lam.param, this.right);
    }
    return new App(this.left.betaReduction(), this.right.betaReduction());
  }

  App subs(string from, Expr to) {
    return new App(this.left.subs(from, to), this.right.subs(from, to));
  }

  string show() {
    return "(" ~ this.left.show() ~ " " ~ this.right.show() ~ ")";
  }
}

class Lambda : Expr {
  string param;
  Expr expr;

  this(string param, Expr expr) {
    this.param = param;
    this.expr = expr;
  }

  Lambda betaReduction() {
    return new Lambda(this.param, this.expr.betaReduction());
  }

  Lambda subs(string from, Expr to) {
    if(this.param == from) {
      return this;
    }

    return new Lambda(this.param, this.expr.subs(from, to));
  }

  string show() {
    return "\\" ~ this.param ~ "." ~ this.expr.show();
  }
} 