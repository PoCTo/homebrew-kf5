require "formula"

class Kf5Solid < Formula
  url "http://download.kde.org/stable/frameworks/5.16/solid-5.16.0.tar.xz"
  sha1 "74be81a3069e228039be35c7e3ab0c54799eb665"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/solid.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
