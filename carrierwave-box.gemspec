# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/box/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-box"
  spec.version       = Carrierwave::Box::VERSION
  spec.authors       = ["Vo Tien An"]
  spec.email         = ["nguoitinh.cuaanh.12@gmail.com"]

  spec.summary       = %q{CarrierWave storage for Box.net/Box.com}
  spec.description   = %q{Box.net/Box.com integration for CarrierWave.}
  spec.homepage      = "https://github.com/thiensubs/carrierwave-box"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "carrierwave", "~> 1.0"
  spec.add_dependency "boxr"
  spec.add_dependency "mechanize"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord", "~> 4.2"
end
