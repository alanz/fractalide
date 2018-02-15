{ support, edges, mods }:

support.node.rs.agent {
  src = ./.;
  edges = with edges.rs; [ CoreAction ];
  mods = with mods.rs; [ (rustfbp_0_3_34 {}) (capnp_0_8_15 {}) ];
}
