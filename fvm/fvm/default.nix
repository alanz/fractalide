{pkgs, components, contracts, support, exeSubnet, ...}:

let
fvm  = support.buildRustPackage rec {
    name = exeSubnet.name;
    src = ./.;
    depsSha256 = "1sh8pjcjq3p38sb2fipxifl0aqkyjpnhk6ac6s9vhj9k63law77i";
    configurePhase = ''
    substituteInPlace src/lib.rs --replace "fs_file_open.so" "${components.fs_file_open}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_parser_lexical.so" "${components.development_fbp_parser_lexical}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_parser_semantic.so" "${components.development_fbp_parser_semantic}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_fvm.so" "${components.development_fbp_fvm}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_errors.so" "${components.development_fbp_errors}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_parser_print_graph.so" "${components.development_fbp_parser_print_graph}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_fbp_scheduler.so" "${components.development_fbp_scheduler}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "development_capnp_encode.so" "${components.development_capnp_encode}/lib/libcomponent.so"
    substituteInPlace src/lib.rs --replace "contract_lookup.so" "${support.contract_lookup}/lib/libcomponent.so"

    substituteInPlace src/lib.rs --replace "path_capnp.rs" "${contracts.path}/src/contract_capnp.rs"
    substituteInPlace Cargo.toml --replace "fvm" "${name}"
    substituteInPlace src/main.rs --replace "fvm" "${name}"
    substituteInPlace src/main.rs --replace "nix-replace-me" "${exeSubnet}/lib/lib.subnet"
    '';

    installPhase = ''
      wrapProgram $out/bin/${name} --prefix LD_PRELOAD : /run/opengl-driver/lib/libGL.so
    '';

    buildInputs = [ pkgs.makeWrapper ];

    meta = with pkgs.stdenv.lib; {
      description = "Fractalide Virtual Machine";
      homepage = https://github.com/fractalide/fractalide;
      license = with licenses; [ agpl3Plus ];
      maintainers = with support.upkeepers; [ dmichiels sjmackenzie ];
  };
};
in
fvm
