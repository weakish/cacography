import ceylon.regex {
    Regex,
    regex
}
import ceylon.test {
    assertEquals,
    test
}
"Render escape marked character."
String escape(String text) {
    Regex re = regex {
        expression = "@\"([@{}])\"";
        global = true;
    };
    return re.replace(text, "$1");
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



