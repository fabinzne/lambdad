import std.stdio, std.conv, std.string : chomp;

import lambda.lexer, lambda.expr, lambda.parse, lambda.pretty;

void main() {
		write("Untyped> ");
		string a = readln.chomp;

		auto lex = new Lexer(a);

		auto parse = new Parser(lex);

		writeln(Pretty.show(new Interpret().betaReduction(parse.app())));
}
