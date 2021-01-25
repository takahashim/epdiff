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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency "rubyzip", "~> 2.3.0"
  s.add_runtime_dependency "pastel"
  s.add_runtime_dependency "tty-file"
  s.add_development_dependency "rake"
end
