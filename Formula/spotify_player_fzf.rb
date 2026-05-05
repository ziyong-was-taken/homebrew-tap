class SpotifyPlayerFzf < Formula
  desc "Spotify player in the terminal with full feature parity"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "19397e2bc685e18a702aab3796f35c69ab1dc6ea093a2623386749b0d1887be3"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    root_url "https://github.com/ziyong-was-taken/homebrew-tap/releases/download/spotify_player_fzf-0.23.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7b9c33ffe0b4207ffdd36d41cc51408bfb18a0811c37ac67d0b015ba885183f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "61b1c1281f4c8bbb5bac086d28c0de2fed577d10b16d9d9fc954f115e5928bf5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib" => :build
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
