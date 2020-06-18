open Data_types
open Encoding
open EzAPI

let section_main = section "API"

let version : (version, exn, no_security) service0 =
  service
    ~section:section_main
    ~name:"version"
    ~output:version
    Path.(root // "version")
