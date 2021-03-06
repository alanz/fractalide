{ agent, edges, mods, pkgs }:

agent {
  src = ./.;
  edges = with edges.rs; [ FsPath FsFileDesc FsFileError ];
  mods = with mods.rs; [ (rustfbp_0_3_34 {}) (capnp_0_8_15 {}) (log_0_4_1 {}) ];
  osdeps = with pkgs; [];
}
