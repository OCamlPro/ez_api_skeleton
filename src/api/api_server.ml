let api_port = ref PConfig.api_port

let load_config filename =
  try
    let ic = open_in filename in
    let json = Ezjsonm.from_channel ic in
    close_in ic ;
    let port = Json_encoding.destruct Encoding.api_config json in
    (match port with None -> () | Some port -> api_port := port);
  with _ -> Printf.eprintf "Fatal error: cannot parse config file %S\n%!" filename

let catch path exn =
  EzAPIServerUtils.Answer.return
    ~headers:EzAPIServerUtils.Answer.headers
    ~code:500 @@
  (Ezjsonm.to_string @@
   `A [
   Json_encoding.(
     construct (obj1
                  (req "error" string))
     @@ path ^ ": " ^ Printexc.to_string exn) ])

let server services =
  Printexc.record_backtrace true;
  Arg.parse [] (fun config_file ->
      load_config config_file) "API server" ;
  let servers = [ !api_port, EzAPIServerUtils.API services ] in
  Lwt_main.run (
    Printf.eprintf "Starting servers on ports [%s]\n%!"
      (String.concat ","
         (List.map (fun (port,_) ->
              string_of_int port) servers));
    EzAPIServer.server ~catch servers
  )

let () =
  server Api.services
