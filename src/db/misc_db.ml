(* open Data_types *)

let version_of_rows = function [ Some v ] -> Int32.to_int v | _ -> 0
