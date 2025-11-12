#!/usr/bin/env ruby
# Script to update Homebrew formula with post_install hook

require 'digest'
require 'net/http'
require 'uri'

version = ENV['VERSION'] || abort("VERSION environment variable required")
repo_name = "layout_uv"
github_user = "easytocloud"

# Download tarball and calculate SHA256
url = "https://github.com/#{github_user}/#{repo_name}/archive/refs/tags/#{version}.tar.gz"
STDERR.puts "Waiting for release tarball to be available..."
STDERR.puts "URL: #{url}"

# Retry logic to wait for GitHub to generate the tarball
max_retries = 10
retry_delay = 5
sha256 = nil

max_retries.times do |attempt|
  begin
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      tarball = response.body
      sha256 = Digest::SHA256.hexdigest(tarball)
      STDERR.puts "SHA256: #{sha256}"
      break
    elsif response.is_a?(Net::HTTPRedirection)
      # Follow redirect
      location = response['location']
      uri = URI(location)
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        tarball = response.body
        sha256 = Digest::SHA256.hexdigest(tarball)
        STDERR.puts "SHA256: #{sha256}"
        break
      end
    end

    STDERR.puts "Attempt #{attempt + 1}/#{max_retries}: Tarball not ready yet, waiting #{retry_delay}s..."
    sleep retry_delay
  rescue => e
    STDERR.puts "Attempt #{attempt + 1}/#{max_retries}: Error: #{e.message}"
    sleep retry_delay
  end
end

abort("Failed to download tarball after #{max_retries} attempts") unless sha256

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
      return if ENV["HOMEBREW_SANDBOX"]

      direnv_lib = "\#{Dir.home}/.config/direnv/lib"
      target_file = "\#{direnv_lib}/layout_uv.sh"
      source_file = "\#{pkgshare}/layout_uv.sh"

      begin
        FileUtils.mkdir_p(direnv_lib)
        FileUtils.cp(source_file, target_file)
        ohai "✓ layout_uv function installed to \#{target_file}"
      rescue => e
        opoo "Could not auto-install layout_uv function: \#{e.message}"
        opoo "Run 'install-layout-uv' manually to complete installation"
      end
    end

    test do
      assert_predicate pkgshare/"layout_uv.sh", :exist?
    end
  end
RUBY

puts formula
STDERR.puts "\nFormula generated successfully!"
