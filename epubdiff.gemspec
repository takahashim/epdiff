# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "epubdiff/version"

Gem::Specification.new do |s|
  s.name        = "epubdiff"
  s.version     = Epubdiff::VERSION
  s.authors     = ["takahashim"]
  s.email       = ["maki@rubycolor.org"]
  s.homepage    = ""
  s.summary     = %q{diff command for EPUB files.}
  s.description = %q{diff command for EPUB files.}

  s.rubyforge_project = "epubdiff"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
