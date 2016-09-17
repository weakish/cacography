"""This implementation is a demostration to show how simple to implement cacography.

   With less than 40 lines of source code, we have a ceylon implementation of cacography.
   In fact, if `replace()` in `ceylon.regex` would accept a transform function as replacement,
   the implementation can be shortened to less than 30 lines.

   It reads the input string into RAM at once.
   So to process very huge text, split it before hand.
   """
shared package io.github.weakish.cacography;
