class Kf5Kconfig < Formula
  desc "Configuration system"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.56/kconfig-5.56.0.tar.xz"
  sha256 "2a970733da16b90ecc317e8ac77f08530650eb2e98dc93834e09e156ec353172"

  head "git://anongit.kde.org/kconfig.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "qt"

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
