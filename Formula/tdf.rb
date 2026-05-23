class Tdf < Formula
  desc "TUI-based PDF viewer"
  homepage "https://github.com/itsjunetime/tdf"
  url "https://github.com/itsjunetime/tdf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f9cdcc89e03efdb002938428905ff6cd9ef7ee9941f7b4fa1f473f9f6c49eb6e"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/ziyong-was-taken/homebrew-tap/releases/download/tdf-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "54718533af7f739ddfffd1ee38a11b1e6e62ee2e7b50ba1cdef6ca9ce0c32f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "25ae1ca1eda222c74db495c469cb07e6fafd0f25fcb46b3bc0153b143a674c0e"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdf --version")
    assert_match "Please specify the file to open", shell_output("#{bin}/tdf 2>&1", 1)
  end
end
