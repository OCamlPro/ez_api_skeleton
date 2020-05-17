open Data_types
(* open Services *)

let (>>=) = Lwt.(>>=)
let return = EzAPIServerUtils.return

let version _params () =
  Dbr.get_version () >>= fun v_db_version -> return {
    v_db = PConfig.database;
    v_db_version
  }
