open Data_types
module S = Services

let host = ref (EzAPI.TYPES.BASE "http://localhost:8080")

let info_encoding = Json_encoding.(
    conv
      (fun {www_apis} -> www_apis)
      (fun www_apis -> {www_apis}) @@
    obj1
      (req "apis" (list string)))

let info_service : www_server_info EzAPI.service0 =
  EzAPI.service
    ~output:info_encoding
    EzAPI.Path.(root // "info.json" )

let init f =
  EzXhr.get0 (Common.host ()) info_service ""
    ~error:(fun code content ->
        let s = match content with
          | None -> "network error"
          | Some content -> "network error: " ^ string_of_int code ^ " -> " ^ content in
        Common.logs s)
    (fun ({www_apis; _} as info) ->
       let api = List.nth www_apis (Random.int @@ List.length www_apis) in
       host := EzAPI.TYPES.BASE api;
       f info) ()


let get0 ?post ?headers ?params ?error service msg f =
  EzXhr.get0 !host service msg ?post ?headers ?error ?params f ()

let get1 ?post ?headers ?params ?error service msg f arg =
  EzXhr.get1 !host service msg ?post ?headers ?error ?params f arg
