module lambda.syntax;

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

  override Var betaReduction() {
    return this;
  }

  override Expr subs(string from, Expr to) {
    if(this.name == from) {
      return to;
    }

    return this;
  }

  override string show() {
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

  override Expr betaReduction() {
    if(auto lam = cast(Lambda) this.left) {
      return lam.expr.subs(lam.param, this.right);
    }
    return new App(this.left.betaReduction(), this.right.betaReduction());
  }

  override App subs(string from, Expr to) {
    return new App(this.left.subs(from, to), this.right.subs(from, to));
  }

  override string show() {
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

  override Lambda betaReduction() {
    return new Lambda(this.param, this.expr.betaReduction());
  }

  override Lambda subs(string from, Expr to) {
    if(this.param == from) {
      return this;
    }

    return new Lambda(this.param, this.expr.subs(from, to));
  }

  override string show() {
    return "\\" ~ this.param ~ "." ~ this.expr.show();
  }
} 