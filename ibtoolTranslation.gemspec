# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ibtoolTranslation/version'

Gem::Specification.new do |spec|
  spec.name          = "ibtoolTranslation"
  spec.version       = IbtoolTranslation::VERSION
  spec.authors       = ["akuraru"]
  spec.email         = ["akuraru@gmail.com"]
  spec.summary       = %q{This is the script that can be used to internationalize the storyboard.}
  spec.description   = %q{This is the script that can be used to internationalize the storyboard.
    
You edit the Translation.strings that is generated when hit the following command. The typing the same command again to be translated.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.18.1"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
