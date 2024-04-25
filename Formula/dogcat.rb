class Dogcat < Formula
  desc "Terminal-based Android Logcat reader with sane colouring"
  homepage "https://github.com/NorseDreki/dogcat"
  url "https://github.com/NorseDreki/dogcat/archive/refs/tags/0.0.9.tar.gz"
  sha256 "896e65b50216618e44038b02c59aa61c403c18beb16dda0a913d7af53bd646d2"
  license "Apache-2.0"
  head "https://github.com/NorseDreki/dogcat.git", branch: "main"

  bottle do
    root_url "https://github.com/NorseDreki/homebrew-tap/releases/download/dogcat-0.0.7"
    sha256 cellar: :any, ventura: "2f264c2b2c1f969556bd2f4a14d8310a9885390bdcb2b4a535da56a9f3032c12"
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
