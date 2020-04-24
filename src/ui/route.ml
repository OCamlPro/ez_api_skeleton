open Js_of_ocaml
open Js

let get_app ?app () = match app with
  | None -> !Vdata.app
  | Some app -> app

let route ?app path =
  Common.logs ("route " ^ path);
  let app = get_app ?app () in
  app##.currentPath := string path;
  match String.split_on_char '/' path with
  | [] -> ()
  | [ path ] -> begin match path with
      | _ -> ()
    end
  | _ -> ()

let route_js (app : Vdata.data_js t) path =
  route ~app (to_string path);
  Common.set_path (to_string path)

let init () =
  Vdata.add_method "route" route_js;
  let path = Common.path () in
  Vdata.add_data "currentPath" (string path);
  Dom_html.window##.onpopstate := Dom_html.handler (fun _e ->
      route @@ Common.path ();
      _true);
  path
