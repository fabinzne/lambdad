module lambda.validator;

import std.conv, std.algorithm : canFind;

bool isReserved(char c) {
  return ['(', ')', '\\', '.'].canFind(c);
}

bool isUseless(char c) {
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

bool isDigit(char c) {
  return to!int(c) >= to!int('0') && to!int(c) <= to!int('9'); 
}

bool isValidStart(char c) {
  return !isDigit(c) && !isUseless(c) && !isDigit(c) && !isReserved(c);
}

bool isValid(char c) {
  return !isUseless(c) && !isDigit(c) && !isReserved(c);
}