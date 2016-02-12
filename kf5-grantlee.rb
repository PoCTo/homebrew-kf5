require "formula"

class Kf5Grantlee < Formula

  homepage 'http://grantlee.org/'
  version '5.0.0'
  url 'http://downloads.grantlee.org/grantlee-5.0.0.tar.gz'
  sha256 'eaf22ba92e53b8eb5dd8bca045fe81b734d3445445ed9e0c1af2a0a7c375b161'

  depends_on "cmake" => :build
  depends_on "qt5" => "with-d-bus"


  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
