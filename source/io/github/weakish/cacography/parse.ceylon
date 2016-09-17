import ceylon.regex {
    Regex,
    regex,
    MatchResult
}

"A processing function takes command and its parameter, returns processed text."
shared alias Processor => String(String, String);


"Parse text for {{command text}}, then invoke a processing function for each command."
String parse(String text, Processor processor) {
    Regex re = regex("""\{\{([^{}\s]+)\s?(([^}]*|.*}[^}].*|.*}))}}""");
    MatchResult[] matches = re.findAll(text);

    String process_match(MatchResult match) {
        String? command = match.groups[0];
        String? parameter = match.groups[1];
        assert (exists command, exists parameter);
        return processor(command, parameter);
    }

    if (nonempty matches) {
        String[] spans = re.split(text);
        assert (nonempty spans);
        String first_span = spans.first;
        {String*} processed_match = { for (match in matches) process_match(match) };
        String[] rest_spans = spans.rest;
        {String*} matches_and_rest_spans = {
            for (pair in zipPairs(processed_match, rest_spans)) "".join(pair)
        };
        return first_span + "".join(matches_and_rest_spans);
    } else {
        return text;
    }
}
