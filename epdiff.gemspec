# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "epdiff/version"

Gem::Specification.new do |s|
  s.name        = "epdiff"
  s.version     = Epdiff::VERSION
  s.authors     = ["takahashim"]
  s.email       = ["maki@rubycolor.org"]
  s.homepage    = ""
  s.summary     = %q{diff command for EPUB files.}
  s.description = %q{diff command for EPUB files.}

  s.rubyforge_project = "epdiff"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
