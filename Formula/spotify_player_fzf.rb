class SpotifyPlayerFzf < Formula
  desc "Spotify player in the terminal with full feature parity"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "211da7f76d412708315ccd36b77424bd53bc4ad19813ed69de44451779812f1f"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    root_url "https://github.com/ziyong-was-taken/homebrew-tap/releases/download/spotify_player_fzf-0.24.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ec7b0eaa6b85719b14ebdc3f453c6b032b586687887d79cd41a7c54bf95ad4f9"
    sha256 cellar: :any,                 x86_64_linux: "aa1f2237bb8b4ac8ec924ef635e416be8cd574a761efc2f2eda7adaec84a1861"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  conflicts_with "spotify_player", because: "both install `spotify_player` binaries"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    features = ["image", "notify", "fzf"]
    system "cargo", "install", *std_cargo_args(path: "spotify_player", features:)
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "https://accounts.spotify.com/authorize", stdout.gets("\n")
  end
end
