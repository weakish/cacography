"""A demostration implementation of cacography template engine.

   The template syntax is simple:

   ```cacography
   {{commad}}
   {{command text parameter}}
   @"@", @"{", @"}"
   ```

   To use render a template, you pass the input String and a processor function to `render` function.
   The processor function has type [[Processor]], i.e. `String(String, String)`.
   The processor function is like a router,
   routing `{{command text}}` to function call `command(text)`.

   ```ceylon
   String output = render(input, processor);
   ```

   Refer the source code of `default_processor` and `verbatim`
   for how to write processor and command function.

   Due to [a bug in `ceylon.regex`][586], Ceylon 1.3.0 (after commit d109037) is required.

   [586]: https://github.com/ceylon/ceylon-sdk/issues/586
   """
module io.github.weakish.cacography "0.0.0" {
    import ceylon.regex "1.3.0";
    import ceylon.test "1.3.0";
}
