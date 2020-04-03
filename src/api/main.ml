let api_port = ref 8080

let speclist = [
  "-p", Arg.Set_int api_port, "API server port";
]

let server services =
  Printexc.record_backtrace true;
  Arg.parse speclist (fun str ->
      Printf.eprintf "Fatal error: unexpected argument %S\n%!" str;
      raise (Arg.Bad str)) "API server" ;
  let servers = [ !api_port, EzAPIServerUtils.API services ] in
  Lwt_main.run (
    Printf.eprintf "Starting servers on ports [%s]\n%!"
      (String.concat ","
         (List.map (fun (port,_) ->
              string_of_int port) servers));
    EzAPIServer.server servers
  )

let () =
  server Api.services
