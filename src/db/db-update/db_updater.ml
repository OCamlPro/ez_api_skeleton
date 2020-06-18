let () =
  EzPGUpdater.main PConfig.database
    ~downgrades:Versions.downgrades
    ~upgrades:Versions.upgrades
