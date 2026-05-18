class Tdf < Formula
  desc "TUI-based PDF viewer"
  homepage "https://github.com/itsjunetime/tdf"
  url "https://github.com/itsjunetime/tdf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f9cdcc89e03efdb002938428905ff6cd9ef7ee9941f7b4fa1f473f9f6c49eb6e"
  license "AGPL-3.0-only"

  depends_on "fontconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = ""
    output = shell_output("#{bin}/tdf #{test_fixtures("test.pdf")}")
    assert_equal expected_output, output
  end
end
