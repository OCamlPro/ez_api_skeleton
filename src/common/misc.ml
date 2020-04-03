let spf fmt = Printf.sprintf fmt

let unoptf def f = function
  | None -> def
  | Some x -> f x

let unopt def = function
  | None -> def
  | Some x -> x

let unopt_exn = function
  | None -> assert false
  | Some x -> x

let convopt f = function
  | None -> None
  | Some x -> Some (f x)

let filter_map f l =
  List.rev @@ List.fold_left (fun acc x ->
      match f x with None -> acc | Some x -> x :: acc) [] l

let shuffle l =
  List.map (fun v -> Random.int 1_000_000, v) l
  |> List.sort (fun (i, _) (i', _) -> compare i i')
  |> List.map snd

let rec sublist ?(start=0) length = function (* not tail rec *)
  | [] when start > 0 -> assert false
  | [] -> []
  | _ when length = 0 -> []
  | _ :: t when start > 0 -> sublist ~start:(start-1) length t
  | h :: t -> h :: sublist (length-1) t

let unopt_list f l =
  List.rev @@ List.fold_left (fun acc elt -> match elt with
      | None -> acc
      | Some elt -> f elt :: acc) [] l

let debug flag fmt =
  if flag then Printf.eprintf fmt
  else Printf.ifprintf stderr fmt

let () =
  Random.self_init ()
