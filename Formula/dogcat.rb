class Dogcat < Formula
  desc "Terminal-based Android Logcat reader with sane colouring"
  homepage "https://github.com/NorseDreki/dogcat"
  url "https://github.com/NorseDreki/dogcat/archive/refs/heads/main.tar.gz"
  version "0.9-RC"
  sha256 "06b208f29556536016d8edd7d1012d964367b144cd43d8d48432fcba360932cf"
  license "Apache-2.0"
  head "https://github.com/NorseDreki/dogcat.git", branch: "main"

  #depends_on "gradle" => :build
  depends_on "openjdk" => :build
  # depends_on xcode: ["12.5", :build]
  depends_on :macos
  depends_on "ncurses"
  #depends_on "android-platform-tools"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableNativeMac#{mac_suffix}"
    system "./gradlew", build_task
    bin.install "build/bin/nativeMac#{mac_suffix}/releaseExecutable/dogcat.kexe" => "dogcat"
  end

  def assert_contains(expected_substring, string, *args)
    assert string.include?(expected_substring), *args
  end

  test do
    output = shell_output("#{bin}/dogcat -c")
    assert_contains "Resolving", output

    output = shell_output(bin/"dogcat -v")
    assert_contains "0.9-RC", output

    # assert_match version.to_s, shell_output("#{bin}/kdoctor --version")
  end
end
