# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vagrant-guest-msys2/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-guest-msys2"
  s.version       = VagrantPlugins::GuestMSYS2::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = "GPL-2.0"
  s.authors       = ["Tobias", "et al"]
  s.email         = "tsmolka@gmail.com"
  s.summary       = "MSYS2 guest for Vagrant"
  s.description   = "Adds MSYS2 (https://sourceforge.net/p/msys2/wiki/Home/) as a guest for Vagrant. "
  s.homepage      = "https://github.com/tsmolka/vagrant-guest-msys2"
  s.required_rubygems_version = ">= 1.3.6"

  # Note that the entire gitignore(5) syntax is not supported, specifically
  # the "!" syntax, but it should mostly work correctly.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }
  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map!    { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end

  s.files         = unignored_files
  s.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  s.require_path  = 'lib'
end

