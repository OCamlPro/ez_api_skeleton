open EzAPIServerUtils

module MakeRegisterer(S: module type of Services)(H:module type of Handlers) = struct

  let register dir =
    dir
  |> register S.version H.version

end

module R = MakeRegisterer(Services)(Handlers)

let services =
  empty |> R.register
