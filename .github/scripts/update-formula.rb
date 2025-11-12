#!/usr/bin/env ruby
# Script to update Homebrew formula with post_install hook

require 'digest'
require 'open-uri'

version = ENV['VERSION'] || abort("VERSION environment variable required")
repo_name = "layout_uv"
github_user = "easytocloud"

# Download tarball and calculate SHA256
url = "https://github.com/#{github_user}/#{repo_name}/archive/refs/tags/#{version}.tar.gz"
puts "Downloading #{url}..."
tarball = URI.open(url).read
sha256 = Digest::SHA256.hexdigest(tarball)

puts "SHA256: #{sha256}"

# Generate formula
formula = <<~RUBY
  class LayoutUv < Formula
    desc "Direnv layout function for uv Python environments"
    homepage "https://github.com/#{github_user}/#{repo_name}"
    url "#{url}"
    sha256 "#{sha256}"
    license "MIT"

    def install
      pkgshare.install "distribution/lib/layout_uv.sh"
      bin.install "distribution/bin/install-layout-uv"
    end

    def post_install
      # Automatically install the direnv function to user's config
      direnv_lib = "\#{Dir.home}/.config/direnv/lib"
      FileUtils.mkdir_p(direnv_lib)
      FileUtils.cp("\#{pkgshare}/layout_uv.sh", "\#{direnv_lib}/layout_uv.sh")
      ohai "✓ layout_uv function installed to \#{direnv_lib}/layout_uv.sh"
    end

    test do
      assert_predicate pkgshare/"layout_uv.sh", :exist?
    end
  end
RUBY

puts formula
puts "\nFormula generated successfully!"
