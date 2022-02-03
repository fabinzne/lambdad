module lambda.pretty;

import lambda.parse;


class Pretty {
  static show(Expr expr) {
    if(auto var = cast(Var) expr) {
      return var.name;
    } else if(auto lam = cast(Lambda) expr) {
      return "\\" ~ lam.param ~ "." ~ Pretty.show(lam.expr);
    } else if(auto app = cast(App) expr) {
      return Pretty.show(app.left) ~ " " ~ Pretty.show(app.right);
    } else {
      return "";
    }
  }
}