require "formula"

class Kf5Llvm37Bin < Formula
  homepage "http://www.llvm.org/"
  url "http://llvm.org/releases/3.7.0/clang+llvm-3.7.0-x86_64-apple-darwin.tar.xz"
  sha256 "057e56b445ac5dfbf0d5475badab374edebe8db5428001c8829340e40724b50d"

  def install
    prefix.install Dir["*"]
  end

  keg_only :provided_by_osx

end