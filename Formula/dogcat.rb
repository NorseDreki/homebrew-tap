class Dogcat < Formula
  desc "Terminal-based Android Logcat reader with sane colouring"
  homepage "https://github.com/NorseDreki/dogcat"
  url "https://github.com/NorseDreki/dogcat/archive/refs/tags/0.0.5.tar.gz"
  sha256 "245a11b235259721b42c70f2640e5dab9941a508aaea2013915ec409daca2a64"
  license "Apache-2.0"
  head "https://github.com/NorseDreki/dogcat.git", branch: "main"

  bottle do
    root_url "https://github.com/NorseDreki/homebrew-tap/releases/download/dogcat-0.9-RC"
    rebuild 1
    sha256 cellar: :any, ventura: "e626cbbd743d3c22f60fd6709bc3235afa37dcc6099e0faff4ca07b98c2c55b3"
  end

  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos
  depends_on "ncurses"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableNativeMac#{mac_suffix}"
    system "./gradlew", build_task
    bin.install "build/bin/nativeMac#{mac_suffix}/releaseExecutable/dogcat.kexe" => "dogcat"
  end

  test do
    output = shell_output(bin/"dogcat -v")
    assert_match "RC", output
  end
end
