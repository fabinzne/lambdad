module interpreter;

import lambda.parse, lambda.expr, lambda.syntax;

class Interpret {
  string exec(Parser p) {
    auto result = p.app().betaReduction();

    while({
      App a = cast(App)result;
      return a !is null;
    }()) {
      result = result.betaReduction();
    }

    return result.show();
  }
}