{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl, CoreServices, cf-private }:

rustPlatform.buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "1i2jcyq6afswxyjifhl5irv84licsad7c83yiy17454mplvrmyg2";
  };

  cargoSha256 = "0hzxwvb5m8mvpfxys4ikkaag6khflh5bfglmay11wf6ayighv834";

  nativeBuildInputs = [ cmake pkgconfig openssl ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices cf-private ];

  postInstall = ''
    install -D -m 444 completions/gutenberg.bash \
      -t $out/share/bash-completion/completions
    install -D -m 444 completions/_gutenberg \
      -t $out/share/zsh/site-functions
    install -D -m 444 completions/gutenberg.fish \
      -t $out/share/fish/vendor_completions.d
  '';

  meta = with stdenv.lib; {
    description = "An opinionated static site generator with everything built-in";
    homepage = https://www.getgutenberg.io;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
