require "formula"
require "language/haskell"

class ScholdocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/timtylin/scholdoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.6/pandoc-citeproc-0.6.tar.gz"
  sha1 "27a88b5dd1637e95096d828e779738771e08e02d"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "scholdoc" => :recommended

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "hsb2hs", "cpphs"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}", "-fembed_data_files", "--ghc-options \"-pgmPcpphs -optP--cpp\""
    end
    cabal_clean_lib
  end

  test do
    bib = testpath/"test.bib"
    bib.write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    assert `scholdoc-citeproc --bib2yaml #{bib}`.include? "- publisher-place: Cambridge"
  end
end
