module interpreter;

import lambda.parse, lambda.expr;

class Interpret {
  string exec(Parser p) {
    return p.app().betaReduction().show();
  }
}