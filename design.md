Design Notes
============

Goals
-----

### Zero logic

A lot of template engine uses a mini language.
cacography chooses a different approach,
be zero logic, delegate expressing logic to the programming language itself.

### Simple to parse

Ideally text should be represented as AST or at least something similar,
like lisp.
Practically, template marks of cacography should be simple to parse.

### Compatible with popular markups

When choosing template marks, cacography avoids collosion with popular markups.

For example:

- `[[WikiName]]` is used in a lot of wiki markup languages
- \`\`code\`\` is used in ReStructuredText and AsciiDoc.

### Compatible with popular input methods

Some templating engines uses `${}`,
where `$` may be converted to local currency symbol in some input methods.
Also, some symbols are hard to type on moblie keyboards.

Gist
----

A programming language parses text for cacography template markup,
replacing cacography marked text with processed result.

When processing cacography marked text,
a programming language converts it to a function call `String? -> String`.

How to convert marked text to function call is left to the implementation to decide.

In the demostration implementation in Ceylon,
`{{verbatim text}}` (we will talk about syntax later) is converted to

```ceylon
// cacographyCommands is entries of `String->String(String)`.
String(String) command = cacographyCommands["verbatim"];
String result = command(text);
```

Syntax
------

To represent the idea of mapping marked text to function call,
choices are `()`, `[]`, and `{}`.

- `()` is commonly used in natural languages.

    `(())` is less used, but accurate to represent complex strucutres.

- `[]` and `[[]]` is commonly used in wiki markups, as metinoed before.

- `{}` is commonly used in programming languages. `{{}}` is not
  (unless a strange formatting style is applied).

Thus cacography chooses `{{}}`.

Now cacography needs to distinguish function name with function parameter.
A lisp like syntax would be `{{verbatim "some text"}}`.

The problem with this syntax is cacography needs to make a choice among:

- quoting all text, thus requring quoting all quoting marks in text
- disable LISP like function call composition, disallowing nested function call.

Another choice is TeX style syntax `＠verbatim{{text}}`, which is harder to parse.

cacography chooses disallowing nested function call.
Nested function call are essentially lambda calculus, aginst the goal logic free.

### Escaping

`@"c"` is `c` itself in rendered output,
where `c` is one of `@`, `{` and `}`.
Only single character is supported.
This is borrowed from Scribble.

For parsing simplicity, escaping is not supported in command identity.
For example, if an implementation allows using `[@"]` in command identity,
then command of `{{@"@" text}}` is `@"@"`, not `@`.

### Command identity

- Spaces are not allowed in command identity.
- For parsing simplicity, `{` and `}` is not allowed in command identity.
- All implementations should support `[_A-z][_A-z0-9]*`.
- Implementions may support other characters in command identity.
