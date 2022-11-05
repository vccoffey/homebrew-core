class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/8e/b0/3777ac29c61c256aba07fcaa2a3c3a32b0bf5cf6f7eb6d800ea1e7809510/all_repos-1.23.1.tar.gz"
  sha256 "6891c738651f4e0963a67f7ce689fe5efe3ba53b32c39b781da1e2e51decff6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "457716ab7ab5031c36fe8bba3dcca36fff3eab8a7605a032c7c5b8c8049e31dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "457716ab7ab5031c36fe8bba3dcca36fff3eab8a7605a032c7c5b8c8049e31dc"
    sha256 cellar: :any_skip_relocation, monterey:       "0bbd196c64b144d3f55b6ed0b728403e668c78eca307ec8cf6260728af543701"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bbd196c64b144d3f55b6ed0b728403e668c78eca307ec8cf6260728af543701"
    sha256 cellar: :any_skip_relocation, catalina:       "0bbd196c64b144d3f55b6ed0b728403e668c78eca307ec8cf6260728af543701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d74f13f684d3c09df1c7a947e2abd1d2b191353275083c980ac4e46c40a003"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/67/e1/869d7b8df41a3ac2a3c74a2a4ba401df468044dccc489b8937aad40d148e/identify-2.5.8.tar.gz"
    sha256 "7a214a10313b9489a0d61467db2856ae8d0b8306fc923e03a9effa53d8aedc58"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system "all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
