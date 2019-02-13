require "formula"
require "language/haskell"

class Scholdoc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/timtylin/scholdoc"
  url "https://hackage.haskell.org/package/scholdoc-0.1.3/scholdoc-0.1.3.tar.gz"
  sha256 "c4d68f7ab5c606479cd2d14f98c6e2e262c2681a3aa469db5b9599322dc94b37"

  bottle do
    root_url 'http://scholarlymarkdown.com/homebrew'
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :high_sierra
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :sierra
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :el_capitan
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :yosemite
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :mavericks
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :mountain_lion
    sha256 "62bf1a24dea3b5d374143084a1c2beb64cf6dedf6c2eb57dff04212dcd225835" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
      system "strip", "-u", "-r", "-arch", "all", "#{prefix}/bin/scholdoc"
    end
    cabal_clean_lib
  end

  test do
    system "scholdoc", "-o", "output.html", prefix/"README-pandoc"
    assert (Pathname.pwd/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
