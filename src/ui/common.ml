let html_escaped s =
  let len = String.length s in
  let b = Buffer.create len in
  for i = 0 to len -1 do
    match s.[i] with
    | '<' -> Buffer.add_string b "&lt;"
    | '>' -> Buffer.add_string b "&gt;"
    | '&' -> Buffer.add_string b "&amp;"
    | '"' -> Buffer.add_string b "&quot;"
    | c -> Buffer.add_char b c
  done;
  Buffer.contents b

let replace id elts = match Js_utils.Manip.by_id id with
  | None -> Js_utils.log "element %s not found" id
  | Some elt -> Js_utils.Manip.replaceChildren elt elts

let replace1 id elt = replace id [ elt ]
