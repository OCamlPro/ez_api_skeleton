open Data_types

let empty () = ()
let version () = Api_request.version ()
let not_found _path = ()

let dispatch = function
  | [] -> empty ()
  | [ path ] -> begin match path with
      | "version" -> version ()
      | _ -> not_found path
    end
  | _ -> not_found (Jsloc.path_string ())

let init () =
  Www_request.info (function
      | None -> ()
      | Some {www_apis} ->
        let api = List.nth www_apis (Random.int @@ List.length www_apis) in
        Api_request.host := EzAPI.TYPES.BASE api;
        dispatch @@ Jsloc.path ())
