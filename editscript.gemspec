$:.push File.expand_path("../lib", __FILE__)
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'editscript/version'

Gem::Specification.new do |s|
  s.name = 'editscript'
  s.version = EditScript::VERSION
  s.author = 'Brett Terpstra'
  s.email = 'me@brettterpstra.com'
  s.homepage = 'http://brettterpstra.com/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A fuzzy search and execute tool for people who write too many scripts'
  s.description = 'EditScript allows you to search through predefined folders or recently-accessed files for scripts with fuzzy matching in path names.'
  s.license = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--title' << 'editscript' << '--main' << 'README.md' << '--markup' << 'markdown' << '-ri'
  s.bindir = 'bin'

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rdoc', '~> 4.1', '>= 4.1.1'
  s.add_runtime_dependency 'term-ansicolor', '~> 1.3', '>= 1.3.0'
  s.add_runtime_dependency 'fuzzy_file_finder', '~> 1.0', '>= 1.0.4'
  s.add_development_dependency 'aruba', '~> 0'

end
