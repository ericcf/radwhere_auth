# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radwhere_auth/version"

Gem::Specification.new do |s|
  s.name        = "radwhere_auth"
  s.version     = RadwhereAuth::VERSION
  s.authors     = ["Eric Carty-Fickes"]
  s.email       = ["ericcf@northwestern.edu"]
  s.homepage    = ""
  s.summary     = %q{Authenticates with a Nuance RadWhere web service.}
  s.description = %q{Authenticates with a Nuance RadWhere web service.}

  s.rubyforge_project = "radwhere_auth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency "fakeweb"
  s.add_runtime_dependency "nokogiri"
end
