require "formula"

class Kf5Knotifications < Formula
  url "http://download.kde.org/stable/frameworks/5.16/knotifications-5.16.0.tar.xz"
  sha1 "5fc93b41eaa9b50066e74fca77806b74b70d9db1"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/knotifications.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  depends_on "haraldf/kf5/kf5-kiconthemes"
  depends_on "haraldf/kf5/kf5-kservice"
  depends_on "haraldf/kf5/kf5-phonon"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
