"The entry point."
shared String render(String input, Processor processor) {
    return escape(parse(input, processor));
}