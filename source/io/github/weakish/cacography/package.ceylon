"""Demostration only.

   The rendering currently requires n+1 passes,
   where `n` is the count of occurence of `{{...}}`.
   The last `1` pass is escaping `@"c"`.

   This can be reduced at least to 2 passes.
   We should split the string on occurence of `{{...}}`,
   process individual parts, then join the string.
   This is the first pass.
   The second pass is escaping.
   Pull-requests are welcome.
   """
shared package io.github.weakish.cacography;
