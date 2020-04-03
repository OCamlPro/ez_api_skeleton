open Data_types
open Encoding

let section_main = EzAPI.section "API"

let version : version EzAPI.service0 =
  EzAPI.service
    ~section:section_main
    ~name:"version"
    ~output:version
    EzAPI.Path.(root // "version")
