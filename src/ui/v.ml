open Js_of_ocaml.Js

class type error = object
  method code : int readonly_prop
  method content : js_string t optdef readonly_prop
end

class type data_js = object
  method path : js_string t prop
  method database : js_string t prop
  method db_version_ : int prop
end

include Vue_js.Make(struct
    type data = data_js
    let id = "app"
  end)

let init path =
  let data_js = object%js
    val mutable path = path
    val mutable database = string ""
    val mutable db_version_ = 0
  end in
  init ~data_js ()
