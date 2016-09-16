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


