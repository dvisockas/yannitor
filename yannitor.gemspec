# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yannitor/version'

Gem::Specification.new do |spec|
  spec.name          = "yannitor"
  spec.version       = Yannitor::VERSION
  spec.authors       = ["Danielius Visockas"]
  spec.email         = ["danieliusvisockas@gmail.com"]

  spec.summary       = %q{Helps you build one-hot or min-max encoded vectors from ActiveRecord collections}
  spec.description   = %q{I'll clean your data}
  spec.homepage      = "https://github.com"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", ["> 3.2.0"]
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
