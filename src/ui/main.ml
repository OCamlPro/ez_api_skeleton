let () =
  let path = Route.init () in
  let app = Vdata.init () in
  Route.route ~app path;
  Request.init (fun _ -> ())
