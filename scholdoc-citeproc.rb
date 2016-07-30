require "formula"
require "language/haskell"

class ScholdocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/timtylin/scholdoc-citeproc"
  url "https://hackage.haskell.org/package/scholdoc-citeproc-0.6/scholdoc-citeproc-0.6.tar.gz"
  sha256 "94c2695699811dfdc84a4fb4352bda5d5086134d92695cd0c2ec8f913267c873"

  bottle do
    root_url 'http://scholarlymarkdown.com/homebrew'
    sha256 "f878b8493ca51f05ff7485240afa69e2982ac5b491fa66cc3b87e6c981c4a3c3" => :el_capitan
    sha256 "f878b8493ca51f05ff7485240afa69e2982ac5b491fa66cc3b87e6c981c4a3c3" => :yosemite
    sha256 "f878b8493ca51f05ff7485240afa69e2982ac5b491fa66cc3b87e6c981c4a3c3" => :mavericks
    sha256 "f878b8493ca51f05ff7485240afa69e2982ac5b491fa66cc3b87e6c981c4a3c3" => :mountain_lion
    sha256 "f878b8493ca51f05ff7485240afa69e2982ac5b491fa66cc3b87e6c981c4a3c3" => :lion
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
