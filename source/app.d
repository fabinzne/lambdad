import std.stdio, std.conv, std.string : chomp;

import lambda.lexer, lambda.expr, lambda.parse;
import interpreter;

void main() {
		write("Untyped> ");
		string a = readln.chomp;

		auto lex = new Lexer(a);

		auto p = new Parser(lex);

		writeln(new Interpret().exec(p));
}
