class Kf5Kcrash < Formula
  desc "Support for application crash analysis and bug report from apps"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.70/kcrash-5.70.0.tar.xz"
  sha256 "37c78b1af6f8cb4645682276bcc7ca2efe9a3cb3364b3c4ac4cbef2b334c5e87"

  head "git://anongit.kde.org/kcrash.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-kcoreaddons"
  depends_on "KDE-mac/kde/kf5-kwindowsystem"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Crash REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
