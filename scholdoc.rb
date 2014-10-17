require "formula"
require "language/haskell"

class Scholdoc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/timtylin/scholdoc"
  url "https://hackage.haskell.org/package/scholdoc-0.1.3/scholdoc-0.1.3.tar.gz"
  sha1 "bae21ae9904bd9740f724f2b9d0c6e211c3db2bf"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "hsb2hs cpphs"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix} -fembed_data_files --ghc-options \"-pgmPcpphs -optP--cpp\""
    end
    cabal_clean_lib
  end

  test do
    system "scholdoc", "-o", "output.html", prefix/"README-pandoc"
    assert (Pathname.pwd/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end