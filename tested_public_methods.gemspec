# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tested_public_methods/version'

Gem::Specification.new do |gem|
  gem.name          = "tested_public_methods"
  gem.version       = TestedPublicMethods::VERSION
  gem.authors       = ["Tomasz Borowski [tbprojects]"]
  gem.email         = 'info.tbprojects@gmail.com'
  gem.description   = "Returns list of public methods that do not have their own unit tests. Gem checkes classes in app directory againts tests in spec directory. Checkout http://betterspecs.org to learn expected conventions in specs."
  gem.summary       = "Returns list of public methods that do not have their own unit tests."
  gem.homepage      = "https://github.com/tbprojects/tested_public_methods"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'colorize'
  gem.add_dependency 'activerecord'
  gem.add_dependency 'colorize'
end