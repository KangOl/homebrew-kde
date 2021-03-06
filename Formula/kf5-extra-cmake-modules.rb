class Kf5ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.70/extra-cmake-modules-5.70.0.tar.xz"
  sha256 "830da8d84cc737e024ac90d6ed767d10f9e21531e5f576a1660d4ca88bee8581"

  revision 3

  head "git://anongit.kde.org/extra-cmake-modules"

  bottle do
    root_url "https://dl.bintray.com/kde-mac/bottles-kde"
    cellar :any_skip_relocation
    sha256 "d71ccf307719d0b26f67525a8eba506a79cc48057bb09274d5cd57796987e896" => :catalina
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qt" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_HTML_DOCS=OFF"
    args << "-DBUILD_QTHELP_DOCS=ON"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
