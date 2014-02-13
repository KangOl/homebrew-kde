require "formula"

class Kf5Kdoctools < Formula
  homepage "http://www.kde.org/"
#  url "http://download.kde.org/unstable/frameworks/4.95.0/kdoctools-4.95.0.tar.xz"
#  sha1 ""

  head 'git://anongit.kde.org/kdoctools.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "docbook"
  depends_on "docbook-xsl"

  def patches
    DATA
  end

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('kf5-extra-cmake-modules').opt_prefix};\""
    args << "-DDocBookXML_CURRENTDTD_DIR:PATH=#{Formula.factory('docbook').prefix}/docbook/xml/4.2"
    args << "-DDocBookXSL_DIR:PATH=#{Formula.factory('docbook-xsl').prefix}/docbook-xsl"

    system "cmake", ".", *args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 56877a3f39b39a6d919c6b18a9c4ab1c0b5a9106..98bf280e7d05e36929f010f5474bb1c3d2f586af 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -8,6 +8,7 @@ set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
 
 include(FeatureSummary)
 include(ECMSetupVersion)
+include(ECMMarkNonGuiExecutable)
 
 set(KF5_VERSION "5.0.0")
 ecm_setup_version(${KF5_VERSION} VARIABLE_PREFIX KDOCTOOLS
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 752604190a4b527d757d4b819dc6d85085a96e4b..6a6be944e867ad4bc285d6bd60dc20591201b3e7 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -49,6 +49,7 @@ else ()
     endif()
 
     add_executable(meinproc5 meinproc.cpp meinproc_common.cpp xslt.cpp ${meinproc_additional_SRCS})
+    ecm_mark_nongui_executable(meinproc5)
     target_link_libraries(meinproc5 Qt5::Core ${LIBXML2_LIBRARIES} ${LIBXSLT_LIBRARIES} ${LIBXSLT_EXSLT_LIBRARIES} ${meinproc_additional_LIBS})
 
     install(TARGETS meinproc5 EXPORT KF5DocToolsTargets ${INSTALL_TARGETS_DEFAULT_ARGS})
@@ -143,13 +144,23 @@ endforeach(_currentcustomizedir ${customizedir})
 
 set( docbookl10nhelper_SRCS docbookl10nhelper.cpp )
 add_executable( docbookl10nhelper ${docbookl10nhelper_SRCS} )
+ecm_mark_nongui_executable( docbookl10nhelper )
 target_link_libraries( docbookl10nhelper Qt5::Core )
 
+if(NOT WIN32)
+    set(docbookl10nhelper_CMD $<TARGET_FILE:docbookl10nhelper>)
+else()
+    # for some reason this is only executed if cmd /k or echo is prepended,
+    # having ${docbookl10nhelper_EXE} as command won't work (VS 2013 x64)
+    set(docbookl10nhelper_CMD cmd /k $<TARGET_FILE:docbookl10nhelper>)
+endif()
+
 add_custom_command( TARGET docbookl10nhelper POST_BUILD
-  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/docbookl10nhelper
-  ${DOCBOOKXSL_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/customization/xsl
-  ${CMAKE_CURRENT_BINARY_DIR}/customization/xsl
+    COMMAND ${docbookl10nhelper_CMD}
+    "${DOCBOOKXSL_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/customization/xsl"
+    "${CMAKE_CURRENT_BINARY_DIR}/customization/xsl"
 )
+
 # all-l10n.xml is generated by docbookl10nhelper
 install(FILES ${CMAKE_CURRENT_BINARY_DIR}/customization/xsl/all-l10n.xml
   DESTINATION ${DATA_INSTALL_DIR}/ksgmltools2/customization/xsl/ )
diff --git a/src/meinproc.cpp b/src/meinproc.cpp
index f34084581205ad4f63a84823cd1a582b2f37ed69..0c0f0f0956cf1fc1b09819fd3dc8b1d7b8f91159 100644
--- a/src/meinproc.cpp
+++ b/src/meinproc.cpp
@@ -26,10 +26,8 @@
 #include <libxslt/xsltutils.h>
 #include <libexslt/exslt.h>
 
-#include <stdlib.h>
 #include <string.h>
-#include <sys/time.h>
-#include <unistd.h>
+#include <qplatformdefs.h>
 #include <qcommandlineparser.h>
 #include <qcommandlineoption.h>
 
diff --git a/src/meinproc_common.cpp b/src/meinproc_common.cpp
index 16234f70e45a703859fce42dcdb2ac1c2fdadade..69699c632e4c9decfc50dd5e16339868ce792452 100644
--- a/src/meinproc_common.cpp
+++ b/src/meinproc_common.cpp
@@ -8,6 +8,18 @@
 
 #include <cstdlib>
 
+#ifdef Q_OS_WIN
+static inline FILE *popen(const char *command, const char *mode)
+{
+    return _popen(command, mode);
+}
+
+static inline int pclose(FILE* file)
+{
+    return _pclose(file);
+}
+#endif
+
 CheckFileResult checkFile(const QString &checkFilename)
 {
     const QFileInfo checkFile(checkFilename);