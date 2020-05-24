(lang dune 2.4)
(allow_approximate_merlin)

(source (uri git://gitlab.com/o-labs/skeleton))
(license MIT)
(authors "John Doe")
(maintainers "john.doe@origin-labs.com")

(package
 (name skeleton)
 (synopsis "Skeleton of website with API REST")
 (bug_reports https://gitlab.com/o-labs/skeleton/-/issues)
 (homepage https://gitlab.com/o-labs/skeleton)
 (depends
  (js_of_ocaml-lwt (= 3.5.2))
  (ocplib-json-typed (>= 0.7.0))
  (lwt (= 4.5.0))
  lwt_log
  ezjsonm
  calendar
  geoip
  (cohttp-lwt-unix (>= 2.0.0))
  re
  (httpaf-lwt-unix (>= 0.6.0))
  (extunix (>= 0.2.0))
  (ocurl (>= 0.8.0))))
