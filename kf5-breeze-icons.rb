require "formula"

class Kf5BreezeIcons < Formula
  homepage "http://www.kde.org/"
 
  head 'git://anongit.kde.org/breeze'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "gettext"
  
  def patches
    DATA
  end

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
   
    support         = "#{Etc.getpwuid.dir}/Library/Application Support"
    systemshare     = HOMEBREW_PREFIX/"share"
  
    ln_sf systemshare/"icons", support

    #interactive_shell
    
  end

  def post_install
    
  end 

  def caveats; <<-EOS.undent
      A symlink "#{ENV['HOME']}/Library/Application Support/icons" was created
      So that KF5 can find the breeze themes.

      This symlink can be removed when this formula is uninstalled.
  EOS
  end
end

__END__

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8435c16..602710b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -23,7 +23,7 @@ else()
   add_subdirectory(cursors)
   add_subdirectory(icons)
   add_subdirectory(icons-dark)
-  add_subdirectory(kdecoration)
+#  add_subdirectory(kdecoration)
   add_subdirectory(kstyle)
   add_subdirectory(misc)
   add_subdirectory(qtquickcontrols)
@@ -32,12 +32,12 @@ else()
   INSTALL(FILES colors/Breeze.colors DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
   INSTALL(FILES colors/BreezeDark.colors DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
   INSTALL(FILES colors/BreezeHighContrast.colors DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
-  find_package(KF5Plasma CONFIG REQUIRED)
-  plasma_install_package(lookandfeel.dark org.kde.breezedark.desktop look-and-feel lookandfeel)
-  if(EXISTS ${CMAKE_SOURCE_DIR}/po AND IS_DIRECTORY ${CMAKE_SOURCE_DIR}/po)
-    find_package(KF5I18n CONFIG REQUIRED)
-    ki18n_install(po)
-  endif()
+#  find_package(KF5Plasma CONFIG REQUIRED)
+#  plasma_install_package(lookandfeel.dark org.kde.breezedark.desktop look-and-feel lookandfeel)
+#  if(EXISTS ${CMAKE_SOURCE_DIR}/po AND IS_DIRECTORY ${CMAKE_SOURCE_DIR}/po)
+#    find_package(KF5I18n CONFIG REQUIRED)
+#    ki18n_install(po)
+#  endif()
 endif()
 
 feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
