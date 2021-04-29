(lang dune 2.4)
(name skeleton)

(source (uri git://gitlab.com/o-labs/skeleton))
(license MIT)
(authors "John Doe")
(maintainers "john.doe@origin-labs.com")
(homepage https://gitlab.com/o-labs/skeleton)
(bug_reports https://gitlab.com/o-labs/skeleton/-/issues)

(package
 (name skeleton)
 (synopsis "Skeleton of website with API REST")
 (depends
  vue-jsoo
  ez_api
  calendar
  geoip
  cohttp-lwt-unix
  re
  pgocaml_ppx
  ez_pgocaml))
