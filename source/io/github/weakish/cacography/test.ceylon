import ceylon.regex {
    Regex,
    regex
}
import ceylon.test {
    assertEquals,
    test
}
"https://github.com/ceylon/ceylon-sdk/issues/586"
test void test_bug_586() {
    Regex bug_586 = regex("^('.*')$|^(\".*\")$");
    assertEquals(bug_586.test("'title'"), true);
}
test void parse_plain_text() {
    String input = "plain text does not contains template marks";
    assertEquals(parse(input, default_processor), input);
}
test void parse_text_with_unmatched_brances() {
    String starting_only = "no {{ ending braces";
    String ending_only = "no strating braces }}";
    assertEquals(parse(starting_only, default_processor), starting_only);
    assertEquals(parse(ending_only, default_processor), ending_only);
}
test void parse_text_with_verbatim_command() {
    String input = "A {{verbatim verbatim}} string";
    String expected = "A verbatim string";
    assertEquals(parse(input, default_processor), expected);
}
test void parse_multiple_verbatims() {
    String input = "Multiple {{verbatim verbatim}} string{{verbatim s}}";
    String expected = "Multiple verbatim strings";
    assertEquals(parse(input, default_processor), expected);
}
test void parse_invalid_verbatim() {
    String input = "{{verbatim}} must have a parameter.";
    String expected = """@"{"{verbatim}} must have a parameter.""";
    assertEquals(parse(input, default_processor), expected);
}
test void parse_unknown_command() {
    String input = "An {{unknown unsupported command}} command.";
    String expected = """An @"{"{unknown unsupported command}} command.""";
    assertEquals(parse(input, default_processor), expected);
}
test void parse_text_with_single_brace() {
    String plain_input = "String f(String x) { return x; }\n";
    assertEquals(parse(plain_input, default_processor), plain_input);
    String input = "{{verbatim String f(String x) { return x; }\n}}";
    assertEquals(parse(input, default_processor), plain_input);
}
test void parse_text_end_with_single_brace() {
    String plain_input = "String f(String x) { return x; }";
    assertEquals(parse(plain_input, default_processor), plain_input);
}
test void parse_too_fancy_to_be_a_command() {
    String fancy_input = "{{{}}}";
    assertEquals(parse(fancy_input, default_processor), fancy_input);
    String fancier_input = "{{}}}}";
    assertEquals(parse(fancier_input, default_processor), fancier_input);
}


test void escape_at_and_braces() {
    String input = "@\"@\"@\"{\"{escaped}@\"}\"";
    String result = "@{{escaped}}";
    assertEquals(escape(input), result);
}
test void not_escape_other_character() {
    String input = "@\"c\"";
    assertEquals(escape(input), input);
}
test void only_escap_single_character() {
    String input = "@\"{{\"";
    assertEquals(escape(input), input);
}
