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

Thus cacography chooses `@`.

Gist
----

A programming language parses text for cacography template markup,
replacing cacography marked text with processed result.

When processing cacography marked text,
a programming language converts it to a function call `String -> String`.

How to convert marked text to function call is left to the implementatino to decide.

In the demostration implementation in Ceylon,
`@verbatim{{text}}` (we will talk about syntax later) is converted to

```ceylon
// cacographyCommands is entries of `String->String(String)`.
String(String) command = cacographyCommands["verbatim"];
String result = command(text);
```

The process is recursive for nested function calls.
`command` in the above example will first parse `text`
for additional cacography marks.

If a cacography command does not need a parameter,
than its parameter is an empty string.

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
- disable LISP like function call composition, allowing only one level.

Instead, cacography chooses a TeX style syntax `＠verbatim{{text}}`.

cacography does not uses `\` in TeX,
since it is hard to type on some keyboards.
cacography does not uses single `{` in TeX and Scribble,
since it requires a lot of quoting.

### Escaping

`@"c"` is `c` itself in rendered output.
This is useful to escape `@`, `{` and `}`.
Only single character is supported.

If a lot of `@...{{` and `}}` are used in text,
cacography provides `@command|--...--|` to escape all of them.

These are inspired by Scribble.

### Shortcuts

#### `@;{{comment}}`

`@;{{comment text}}` is a shortcut of `@comment{{comment text}}`.
`comment text` will be removed in rendered output.
This is inspired by Scribble's `@;{comment}`.
Scribble's `@;one line comment` is not supported, though.