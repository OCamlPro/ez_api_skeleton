open Data_types
module S = Services

let host = ref (EzAPI.TYPES.BASE PConfig.web_host)

let wrap_res ?error f = function
  | Ok x -> f x
  | Error exn -> let s = Printexc.to_string exn in match error with
    | None -> Common.logs s
    | Some e -> e 500 (Some s)

let get0 ?post ?headers ?params ?error ?(msg="") ?(host= !host) service f =
  EzRequest.ANY.get0 host service msg ?post ?headers ?error ?params (wrap_res ?error f) ()
let get1 ?post ?headers ?params ?error ?(msg="") ?(host= !host) service f arg =
  EzRequest.ANY.get1 host service msg ?post ?headers ?error ?params (wrap_res ?error f) arg

let info_encoding = Json_encoding.(
    conv
      (fun {www_apis} -> www_apis)
      (fun www_apis -> {www_apis}) @@
    obj1
      (req "apis" (list string)))

let info_service : (www_server_info, exn, EzAPI.no_security) EzAPI.service0 =
  EzAPI.service
    ~output:info_encoding
    EzAPI.Path.(root // "info.json" )


let init f =
  get0 ~host:(Common.host ()) info_service
    ~error:(fun code content ->
        let s = match content with
          | None -> "network error"
          | Some content -> "network error: " ^ string_of_int code ^ " -> " ^ content in
        Common.logs s)
    (fun ({www_apis; _} as info) ->
       let api = List.nth www_apis (Random.int @@ List.length www_apis) in
       host := EzAPI.TYPES.BASE api;
       f info)
