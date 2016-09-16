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

    re.split(text);
    String process_one_match(MatchResult match) {
        String? command = match.groups[0];
        String? parameter = match.groups[1];
        assert (exists command, exists parameter);
        return processor(command, parameter);
    }

    if (nonempty matches) {
        String process_span(String span, MatchResult match) {
            return process_one_match(match) + span.spanFrom(match.end - match.start);
        }
        String text_head = text.spanTo(matches.first.start - 1);
        String text_tail = text.spanFrom(matches.last.start);
        String text_tail_processed = process_span(text_tail, matches.last);
        if (matches.size == 1) {
            return text_head + text_tail_processed;
        } else {
            {Integer*} matches_start = { for (match in matches) match.start };
            {Integer[2]*} span_endpoints = {
                for (endpoints in zipPairs(matches_start, matches_start.rest))
                [endpoints[0], endpoints[1] - 1]
            };
            {[Integer[2], MatchResult]*} matched_spans = zipPairs(span_endpoints, matches);
            {String*} text_rest = {
                for (pair in matched_spans)
                process_span(text.span(pair[0][0], pair[0][1]), pair[1])
            };
            return text_head + "".join(text_rest) + text_tail_processed;
        }
    } else {
        return text;
    }
}
