let () =
  EzPGUpdater.main SConfig.database
    ~downgrades:Versions.downgrades
    ~upgrades:Versions.upgrades
