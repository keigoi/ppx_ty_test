# ppx_ty_test

See: https://qiita.com/keigoi/items/180ae6e08e16d9a89c98


# Try it

(Checked under OCaml 5.3.0)

```
$ cat test/test.ml

let f x = x + 1

(* let f x = ((x + 42) + (1 + 42)) + 42 *)

$ dune build

$ ocamlc -dsource _build/default/test/test.pp.ml -stop-after parsing

...

let f x = ((x + 42) + (1 + 42)) + 42
```

