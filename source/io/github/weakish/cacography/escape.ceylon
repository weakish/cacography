import ceylon.regex {
    Regex,
    regex
}
"Render escape marked character."
String escape(String text) {
    Regex re = regex {
        expression = "@\"([@{}])\"";
        global = true;
    };
    return re.replace(text, "$1");
}
