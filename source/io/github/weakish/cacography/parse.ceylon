import ceylon.regex {
    Regex,
    regex,
    MatchResult
}
import ceylon.test {
    assertEquals,
    test
}

"A processing function takes command and its parameter, returns processed text."
shared alias Processor => String(String, String);

"Parse text for {{command text}}, then invoke a processing function for each command."
String parse(String text, Processor processor) {
    Regex re = regex("""\{\{([^\s}]+)\s?([^}]*)}}""");
    variable String in_process = text;

    String process_one_match(MatchResult match) {
        String? command = match.groups[0];
        String? parameter = match.groups[1];
        assert (exists command, exists parameter);
        return processor(command, parameter);
    }

    while (is MatchResult match = re.find(in_process)) {
        in_process = re.replace(in_process, process_one_match(match));
    }
    return in_process;
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

"Default processing function, only process [[verbatim]].
 Returns `{{command text}}` when command is unknown."
shared String default_processor(String command, String text) {
    switch (command)
    case ("verbatim") {
        return verbatim(text);
    }
    else {
        return """@"{"{""" + command + (if (text.empty) then "" else " " + text) + "}}";
    }
}

"Returns parameter text verbatim.
 Returns quoted `{{verbatim}}` if there is no parameter (empty)"
shared String verbatim(String text) {
    if (text.empty) {
        return """@"{"{verbatim}}""";
    } else {
        return text;
    }
}