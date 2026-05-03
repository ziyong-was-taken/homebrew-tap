class SpotifyPlayerFzf < Formula
  desc "Spotify player in the terminal with full feature parity"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "19397e2bc685e18a702aab3796f35c69ab1dc6ea093a2623386749b0d1887be3"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
