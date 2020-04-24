open Js_of_ocaml.Js

class type error = object
  method code : int readonly_prop
  method content : js_string t optdef readonly_prop
end

class type data_js = object
  method currentPath : js_string t prop
end

include Vue_js.Make(struct
    type data = data_js
    let id = "app"
  end)

let init () =
  init ()
