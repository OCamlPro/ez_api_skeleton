
let downgrade_1_to_0 = []

let upgrade_0_to_1 dbh version =
  EzPG.upgrade ~dbh ~version ~downgrade:downgrade_1_to_0 []

let upgrades = [
  0, upgrade_0_to_1
]

let downgrades = [
  1, downgrade_1_to_0
]
