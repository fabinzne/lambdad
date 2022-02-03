module lambda.error;

import std.conv;

class EOFError : Throwable {
  this(string file, int line) {
    super("Unexpected end of file!", file, line);
  }
}

class SyntaxError : Throwable {
  this(string expected, string got, int col, string file, int line) {
    super("Expected: " ~ expected ~ 
          " but got: " ~ got ~ 
          " at (col, line) >> " ~ 
          "(" ~ to!string(col) ~ "," ~ to!string(line) ~ ")",
          file,
          line);
  }
}

class UnrecognizeError : Throwable {
  this(string unrecodized, int col, int line, string tile) {
    super("Unrecognized: " ~ unrecodized ~ 
          " at (col, line) >> " ~ 
          "(" ~ to!string(col) ~ "," ~ to!string(line) ~ ")",
          tile,
          line);
  }
}

class UnexpectedError : Throwable {
  this(string expected, string got, int col, int line, string file) {
    super("Expected " ~ expected ~ " but instead got " ~ got ~ 
          " at (col, line) >> " ~ 
          "(" ~ to!string(col) ~ "," ~ to!string(line) ~ ")",
          file,
          line);
  }
}