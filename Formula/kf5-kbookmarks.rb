class Kf5Kbookmarks < Formula
  desc "Support for bookmarks and the XBEL format"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.47/kbookmarks-5.47.0.tar.xz"
  sha256 "93d71e429b0718f0681b4d297290e524b12cac8e96bff080d391ee3bae178b2c"

  head "git://anongit.kde.org/kbookmarks.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "KDE-mac/kde/kf5-kxmlgui"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end
end
