class Kf5Kxmlrpcclient < Formula
  desc "XML-RPC client library for KDE"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.58/kxmlrpcclient-5.58.0.tar.xz"
  sha256 "53f647bb8d9165ddf6326703486470c7e9fc4ef392991501319e5c69f25f0ea3"
  head "git://anongit.kde.org/kxmlrpcclient.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-kio"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5XmlRpcClient REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
