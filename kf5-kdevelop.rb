require "formula"

class Kf5Kdevelop < Formula
  #url "git://anongit.kde.org/kdevelop.git", :using => :git
  #, :revision => "97fea817e6e5746e3d8b631ac7e9171a3e1f424b"
  #sha1 "9b4cf77b753f6847f10709bb616c55c8e515c53c"
  homepage "http://www.kdevelop.org/"

  head "git://anongit.kde.org/kdevelop.git", :branch => 5.0 #, :revision => "0cb7ea4e5193e53f4b4a5e2b5850d8ed64ff5259"
  
  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  #depends_on "llvm" => "with-clang"

  # homebrew's llvm 3.6.2 fails to compile against
  # homebrew's llvm --HEAD is highly unstable, using binary version 3.7 from llvm.org
  depends_on "kf5-llvm37-bin"

  depends_on "gettext" => :build
  depends_on "haraldf/kf5/kf5-kdevplatform"
  #depends_on "haraldf/kf5/kf5-kded"
  depends_on "haraldf/kf5/kf5-kglobalaccel"
  depends_on "kf5-kiconthemes"
  depends_on "kf5-breeze-icons"

  def patches
    DATA
  end
  
  def install

    # don't create mime-databae in Keg -- do this later
    inreplace "app/CMakeLists.txt", 'update_xdg_mimetypes(', '#update_xdg_mimetypes('
    # simplify icon name -- avoid rename step later
    inreplace "app/CMakeLists.txt", "kdevelop_SRCS.icns", "kdevelop.icns"

    mkdir "build" do
        #LLVM 3.6.2 in library_paths breaks linking against sytem libs of the same name
        #ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

        args = std_cmake_args

        system "cmake", *args, ".."

        #interactive_shell
        
        inreplace "app/kdevelop.app/Contents/Info.plist", <<-'BEFORE', <<-'AFTER'
</dict>
</plist>
BEFORE
    <key>LSEnvironment</key>
    <dict>
        <key>QT_PLUGIN_PATH</key>
        <string>/usr/local/lib/plugins:/usr/local/lib/qt5/plugins:/usr/local/lib/kf5/plugins:/usr/local/opt/qt5/plugins</string>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin</string>
    </dict>
</dict>
</plist>
AFTER

        #interactive_shell
        system "make", "install"
        
        #interactive_shell
        prefix.install "install_manifest.txt"
    

        # build and install app icon
        mkdir prefix/"kdevelop.app/Contents/Resources" do 
            system Formula["kf5-kiconthemes"].opt_bin/"ksvg2icns", 
                   Formula["kf5-breeze-icons"].opt_share/"icons/breeze/apps/48/kdevelop.svg"
        end 
    end
    
    #fix icons to work as part of 'breeze' theme
    mv share/"icons/hicolor", share/"icons/breeze"
    mv share/"kdevelop/icons/hicolor", share/"kdevelop/icons/breeze"

    # remove icons that conflict with breeze theme before linking
    Dir.glob(share/"icons/breeze/**/kdevelop.*") { |icon| File.delete(icon) }



  end

  def post_install

    #update mime-database in homebrew system
    system "update-mime-database", HOMEBREW_PREFIX/"share/mime"  

    # Make findable from QStandardPaths:
    support  = "#{Etc.getpwuid.dir}/Library/Application Support"
    prefs    = "#{Etc.getpwuid.dir}/Library/Preferences"
    systemshare    = HOMEBREW_PREFIX/"share"
  
    ln_sf systemshare/"icons", support
    #ln_sf systemshare/"appdata", support
    #ln_sf systemshare/"applications", support
    ln_sf systemshare/"kdevappwizard", support
    ln_sf systemshare/"kdevcodegen", support
    ln_sf systemshare/"kdevelop", support
    ln_sf systemshare/"kdevfiletemplates", support
    ln_sf systemshare/"kdevmanpage", support

    # all prefs
    system "ln -sf /usr/local/etc/xdg/*  #{prefs}"

  end

end

__END__

 
diff --git a/languages/cpp/preprocessjob.cpp b/languages/cpp/preprocessjob.cpp
index d84a445..59cf286 100644
--- a/languages/cpp/preprocessjob.cpp
+++ b/languages/cpp/preprocessjob.cpp
@@ -197,7 +197,7 @@ void PreprocessJob::run(ThreadWeaver::JobPointer self, ThreadWeaver::Thread* thr
             }
           } else if (fileFeaturesSatisfied && !slaveFeaturesSatisfied) {
             // This is strange, because importees should not require more features than the importer
-            qCDebug(CPP) << "Slaves require more features than file itself" << parentJob()->slaveMinimumFeatures() << updatingEnvironmentFile->features() << parentJob()->document().toUrl();
+            qCDebug(CPP) << "Slaves require more features than file itself" << (unsigned)parentJob()->slaveMinimumFeatures() << (unsigned)updatingEnvironmentFile->features() << parentJob()->document().toUrl();
           }
         }
     }
diff --git a/languages/plugins/custom-definesandincludes/CMakeLists.txt b/languages/plugins/custom-definesandincludes/CMakeLists.txt
index 810b2dc..011e6b4 100644
--- a/languages/plugins/custom-definesandincludes/CMakeLists.txt
+++ b/languages/plugins/custom-definesandincludes/CMakeLists.txt
@@ -39,6 +39,7 @@ target_link_libraries( kdevdefinesandincludesmanager LINK_PRIVATE
 option(BUILD_kdev_includepathsconverter "Build utility to modify include paths of a project from command line." ON)
 if(BUILD_kdev_includepathsconverter)
     add_executable(kdev_includepathsconverter includepathsconverter.cpp)
+    ecm_mark_nongui_executable(kdev_includepathsconverter)
     target_link_libraries(kdev_includepathsconverter LINK_PRIVATE
         ${KDEVPLATFORM_PROJECT_LIBRARIES}
         kdevcompilerprovider
