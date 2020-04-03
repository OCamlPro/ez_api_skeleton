open Data_types
module S = Services

let host = ref (EzAPI.TYPES.BASE "http://localhost:8080")

let get0 ?post ?headers ?params ?error service msg f =
  EzXhr.get0 !host service msg ?post ?headers ?error ?params f ()

let get1 ?post ?headers ?params ?error service msg f arg =
  EzXhr.get1 !host service msg ?post ?headers ?error ?params f arg

let version () =
  get0 S.version "version" (fun v ->
      let open Ocp_js.Html in
      Common.replace1 "content" @@ div [
        div [ txt @@ Misc.spf "commit: %s" v.v_commit ];
        div [ txt @@ Misc.spf "date: %s" v.v_date ];
        div [ txt @@ Misc.spf "database: %s" v.v_db ];
        div [ txt @@ Misc.spf "db-version: %d" v.v_db_version ] ])
