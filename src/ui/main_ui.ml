let () =
  EzRequest.ANY.init ();
  let path = Route.init () in
  let app = V.init (Js_of_ocaml.Js.string path) in
  Request.init (fun _ ->
      Route.route ~app path
    )
