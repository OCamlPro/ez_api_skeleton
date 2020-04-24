let database = PConfig.database
let unix_domain_socket_dir = "/var/run/postgresql"
let verbose_mode = ref false
let verbose_counter = ref 0

let debug fmt = Misc.debug !verbose_mode fmt

module M = Monad_lwt

module PGOCaml = struct
  include PGOCaml_generic.Make(M)

  let prepare dbh ~name ~query () =
    if !verbose_mode then
      Printf.eprintf "DB %S PREPARE %s\n%!" name query;
    prepare dbh ~name ~query ()

  let execute_rev dbh ~name ~params () =
    if !verbose_mode then begin
      incr verbose_counter;
      let counter = !verbose_counter in
      Printf.eprintf "DB x%dx begin %s\n%!" counter name;
      bind (execute_rev dbh ~name ~params ())
        (fun rows ->
           Printf.eprintf "DB x%dx end %s\n%!" counter name;
           return rows)
    end else
      execute_rev dbh ~name ~params ()
end

type database_handle = (string, bool) Hashtbl.t PGOCaml.t

let (>>=) = M.(>>=)

let dbh_pool : database_handle Lwt_pool.t =
  let validate conn =
    PGOCaml.alive conn >>= fun is_alive ->
    debug "[Reader] Validate connection : [%b]\n%!" is_alive ;
    M.return is_alive in
  let check _conn is_ok =
    debug "[Reader] Check connection.\n%!" ;
    is_ok false in
  let dispose conn =
    debug "[Reader] Dispose connection.\n%!" ;
    PGOCaml.close conn in
  M.pool_create ~check ~validate ~dispose 20 (fun () ->
      PGOCaml.connect ?host:None ~unix_domain_socket_dir ~database ())

let with_dbh f = M.pool_use dbh_pool f

let (>>>) f g = f g

let return = M.return

let of_dbf f = function
  | [ c ] -> return (Some (f c))
  | _ -> return None
let of_db_unoptf f = function
  | [ Some c ] -> return (f c)
  | _ -> return (f 0L)
let of_db_optf f = function
  | [ Some c ] -> return (Some (f c))
  | _ -> return None
let of_db_exnf f = function
  | [ c ] -> return (f c)
  | _ -> assert false

let of_db : string list -> string option M.t = of_dbf (fun x -> x)
let of_db_unopt = of_db_unoptf (fun x -> x)
let of_db_opt x = of_db_optf (fun x -> x) x
let of_db_exn x = of_db_exnf (fun x -> x) x
let of_count = of_dbf Int64.to_int
let of_count_unopt = of_db_unoptf Int64.to_int
let of_count_opt = of_db_optf Int64.to_int
let test_optf f = function
  | None -> None, true
  | Some x -> Some (f x), false
let test_opt x = test_optf (fun x -> x) x

let pg_lock f =
  with_dbh >>> fun dbh ->
  [%pgsql dbh "BEGIN"] >>= fun () ->
  f dbh >>= fun () ->
  [%pgsql dbh "COMMIT"]

let pagination page page_size =
  Int64.of_int (page * page_size), Int64.of_int page_size
