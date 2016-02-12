require "formula"

class Kf5Kdevplatform < Formula
  homepage "http://www.kdevelop.org/"

  head "git://anongit.kde.org/kdevplatform.git", :branch => 5.0#, :revision => "25e98f4b101b26a570633e82d4863fcb834423b3"
  
  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  depends_on "gettext" => :build
  depends_on "haraldf/kf5/kf5-threadweaver" 
  depends_on "haraldf/kf5/kf5-kcmutils"

  depends_on "kf5-grantlee"
  depends_on "kf5-libkomparediff2"
  depends_on "haraldf/kf5/kf5-knotifyconfig"
  depends_on "haraldf/kf5/kf5-knewstuff"
  depends_on "haraldf/kf5/kf5-kitemmodels"
  depends_on "haraldf/kf5/kf5-ktexteditor"

  def patches
    DATA
  end

  def install
    args = std_cmake_args
    args << "-DBOOST_ROOT=/usr/local/opt/boost/"

    #system <<-'FIXUP'

        ## make install dirs KF5
        ## -- decided not to do this, there's so much more to change to make this 'isolated' from kde4
        ## -- keeping here if change mind
        #git ls-files -z '*CMakeLists.txt' '*.dox' '*.cmake*'  | xargs -0 sed -i.bak \
        #         -e 's/KDE_INSTALL_INCLUDEDIR/KDE_INSTALL_INCLUDEDIR_KF5/g'\
        #         -e 's/KDE_INSTALL_LIBEXECDIR/KDE_INSTALL_LIBEXECDIR_KF5/g'\
        #         -e 's/KDE_INSTALL_DATADIR/KDE_INSTALL_DATADIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_INCLUDEDIR/KDE_INSTALL_INCLUDEDIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_LIBEXECDIR/KDE_INSTALL_LIBEXECDIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_DATADIR/KDE_INSTALL_DATADIR_KF5/g'\
        #         -e 's/INCLUDE_INSTALL_DIR/KDE_INSTALL_INCLUDEDIR_KF5/g'
        #         
        ## make this work as a KF5 cmake module
        #git ls-files -z '*CMakeLists.txt' '*.cmake*' | xargs -0 sed -i.bak \
        #             -e 's/KDevPlatformConfig/KF5KDevPlatformConfig/g'\
        #             -e 's/KDevPlatformMacros/KF5KDevPlatformMacros/g'\
        #             -e 's/KDevPlatformTargets/KF5KDevPlatformTargets/g'\
        #             -e 's/KDE_INSTALL_CMAKEPACKAGEDIR}\/KDevPlatform/KDE_INSTALL_CMAKEPACKAGEDIR}\/KF5KDevPlatform/g'
        #         
        #    
        #git mv KDevPlatformConfig.cmake.in KF5KDevPlatformConfig.cmake.in
        #
        #git mv cmake/modules/KDevPlatformMacros.cmake cmake/modules/KF5KDevPlatformMacros.cmake

    #FIXUP

    mkdir "build" do
        system "PATH=/usr/local/opt/boost/:$PATH cmake", *args, ".."
        #interactive_shell
        system "make", "install"
        prefix.install "install_manifest.txt"
    end
  end
end

__END__

#################################################################
#  patch concerning cmath
#################################################################

diff --git a/util/texteditorhelpers.cpp b/util/texteditorhelpers.cpp
index 0a596e7..eba9ecd 100644
--- a/util/texteditorhelpers.cpp
+++ b/util/texteditorhelpers.cpp
@@ -21,6 +21,8 @@
 
 #include "KTextEditor/View"
 
+#include <cmath>
+
 namespace KDevelop {
 
 namespace {
@@ -34,7 +36,7 @@ int getLineHeight(const KTextEditor::View* view, int curLine)
   if (view->cursorToCoordinate(c).y() < 0) {
     c.setLine(curLine - 1);
   }
-  return std::abs(view->cursorToCoordinate(c).y() - currentHeight);
+  return std::abs((double)(view->cursorToCoordinate(c).y() - currentHeight));
 }
 
 }

#################################################################
#  patch sessions to be in CacheLocation -- prevent conflict with other ~/Library/Application Support/kdevelop directory
#################################################################

diff --git a/shell/sessioncontroller.cpp b/shell/sessioncontroller.cpp
index a4344d8..f95f9a6 100644
--- a/shell/sessioncontroller.cpp
+++ b/shell/sessioncontroller.cpp
@@ -291,8 +291,7 @@ public:
 
     static QString sessionBaseDirectory()
     {
-        return QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)
-            +'/'+ qApp->applicationName() + "/sessions/";
+        return QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/sessions/";
     }
 
     QString ownSessionDirectory() const


