let str_opt s = Arg.String (fun x -> s := Some x)

let () =
  let output_file = ref "openapi.json" in
  let descr, version, title, terms, contact, license, servers =
    ref None, ref None, ref None, ref None, ref None, ref None, ref None in
  let speclist =
    [ "-o", Arg.String (fun s -> output_file := s), "Optional name (path) of output file";
      "--descr", str_opt descr, "Optional API description";
      "--version", str_opt version, "Optional API version";
      "--title", str_opt title, "Optional API title";
      "--terms", str_opt terms, "Optional API terms";
      "--contact", str_opt contact, "Optional API contact";
      "--license", Arg.Tuple [
        Arg.String (fun s -> license := Some (s,""));
        Arg.String (fun s -> match !license with
            | None -> license := None
            | Some (a, _) -> license := Some (a, s))], "Optional API license";
      "--servers", Arg.Tuple [
        Arg.String (fun s ->
            let before = match !servers with
              | None -> []
              | Some l -> l in
            servers := Some ((s,"") :: before));
        Arg.String (fun s -> match !servers with
            | Some ((a, _) :: t) -> servers := Some ((a, s) :: t)
            | _ -> servers := None)], "Optional API license"
    ] in
  let usage_msg = "Create a openapi json file with the services of the API" in
  Arg.parse speclist (fun _ -> ()) usage_msg;
  let sections = Services.sections in
  let str = EzSwagger.to_string
      ?descr:!descr ?version:!version ?title:!title ?terms:!terms ?license:!license
      ?servers:!servers ?contact:!contact ~docs:Doc.doc sections in
  let oc = open_out !output_file in
  output_string oc str;
  close_out oc
