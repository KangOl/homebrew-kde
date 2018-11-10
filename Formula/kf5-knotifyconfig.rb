class Kf5Knotifyconfig < Formula
  desc "Configuration system for KNotify"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.52/knotifyconfig-5.52.0.tar.xz"
  sha256 "bd4c9ab350e0dc7f09fb0625d05467d8f9ccf5350ef0470879d8e52572043d4d"

  head "git://anongit.kde.org/knotifyconfig.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "KDE-mac/kde/kf5-kio"

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
