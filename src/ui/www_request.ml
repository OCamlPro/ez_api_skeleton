open Ocp_js
open Data_types

let info_encoding = Json_encoding.(
    conv
      (fun {www_apis} -> www_apis)
      (fun www_apis -> {www_apis}) @@
    obj1 (req "apis" (list string)))

let info_service : www_server_info EzAPI.service0 =
  EzAPI.service
    ~params:[]
      ~name:"info"
      ~output:info_encoding
      EzAPI.Path.(root // "info.json" )

let host = match Jsloc.url () with
  | Url.Http hu -> Misc.spf "http://%s:%d" hu.Url.hu_host hu.Url.hu_port
  | Url.Https hu -> Misc.spf "https://%s:%d" hu.Url.hu_host hu.Url.hu_port
  | _ -> "http://localhost:8888"

let error json_name status content =
  let content = match content with
    | None -> "network error"
    | Some content -> content in
  Js_utils.log "/%s.json: error %d: %s\n%!" json_name status content


let info f =
  EzXhr.get0 (EzAPI.TYPES.BASE host) info_service "www.info"
    ~error:(fun code content -> error "info" code content; f None)
    (fun info -> f (Some info)) ()
