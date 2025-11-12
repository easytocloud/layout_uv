class LayoutUv < Formula
  desc "Direnv layout function for uv Python environments"
  homepage "https://github.com/easytocloud/layout_uv"
  url "https://github.com/easytocloud/layout_uv/archive/refs/tags/v__VERSION__.tar.gz"
  sha256 "__SHA256__"
  license "MIT"

  def install
    pkgshare.install "distribution/lib/layout_uv.sh"
    bin.install "distribution/bin/install-layout-uv"
  end

  def post_install
    # Automatically install the direnv function to user's config
    direnv_lib = "#{Dir.home}/.config/direnv/lib"
    FileUtils.mkdir_p(direnv_lib)
    FileUtils.cp("#{pkgshare}/layout_uv.sh", "#{direnv_lib}/layout_uv.sh")
    ohai "✓ layout_uv function installed to #{direnv_lib}/layout_uv.sh"
  end

  test do
    assert_predicate pkgshare/"layout_uv.sh", :exist?
  end
end
