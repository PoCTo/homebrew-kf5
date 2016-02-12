require "formula"

class Kf5Libkomparediff2 < Formula

  url  'http://download.kde.org/stable/applications/15.08.2/src/libkomparediff2-15.08.2.tar.xz'
  sha256 "62583fe45e9d3e507595ebf925a603ac5e2354f7e5d5449dfc3a679b9423ccd7"
  head 'git://anongit.kde.org/libkomparediff2.git'

  depends_on "cmake" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "gettext" => :build
  depends_on "haraldf/kf5/kf5-kcoreaddons"
  depends_on "haraldf/kf5/kf5-kconfig"
  depends_on "haraldf/kf5/kf5-kxmlgui"
  depends_on "haraldf/kf5/kf5-ki18n"
  depends_on "haraldf/kf5/kf5-kio"
  depends_on "haraldf/kf5/kf5-kparts"



  def install
    args = std_cmake_args

    mkdir "build" do
        system "cmake", *args , ".."
        system "make", "install"
        prefix.install "install_manifest.txt"
    end
  end
end
