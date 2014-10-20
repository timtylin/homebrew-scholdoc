require "formula"
require "language/haskell"

class ScholdocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/timtylin/scholdoc-citeproc"
  url "https://hackage.haskell.org/package/scholdoc-citeproc-0.6/scholdoc-citeproc-0.6.tar.gz"
  sha1 "27a88b5dd1637e95096d828e779738771e08e02d"

  bottle do
    root_url 'http://scholarlymarkdown.com/homebrew'
    sha1 "a9f2e7a0bf621c7358d5171b563dcd64790b72f1" => :yosemite
    sha1 "a9f2e7a0bf621c7358d5171b563dcd64790b72f1" => :mavericks
    sha1 "a9f2e7a0bf621c7358d5171b563dcd64790b72f1" => :mountain_lion
    sha1 "a9f2e7a0bf621c7358d5171b563dcd64790b72f1" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "scholdoc" => :recommended

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
      system "strip", "-u", "-r", "-arch", "all", "#{prefix}/bin/scholdoc-citeproc"
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
