open Json_encoding
open Data_types

let version = conv
  (fun {v_commit; v_date; v_db; v_db_version} -> (v_commit, v_date, v_db, v_db_version))
  (fun (v_commit, v_date, v_db, v_db_version) -> {v_commit; v_date; v_db; v_db_version}) @@
  obj4
    (req "commit" string)
    (req "date" string)
    (req "db" string)
    (req "db_version" int)
