# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datebox'

Gem::Specification.new do |gem|
  gem.name          = "datebox"
  gem.version       = Datebox::VERSION
  gem.authors       = ["Robert Borkowski"]
  gem.email         = ["robert.borkowski@forward3d.com"]
  gem.description   = %q{Offers help with managing dates and periods}
  gem.summary       = %q{Got fed up with implementing date related functionality everywhere}
  gem.homepage      = "https://github.com/forward3d/datebox"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = [] #gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = [] #gem.files.grep(%r{^(test|spec|features)/})
  # gem.test_files    = `git grep test`.split(/\n/).map {|f| File.basename(f.split(':').first)}
  gem.require_paths = ["lib"]

  gem.license = 'MIT'

end
