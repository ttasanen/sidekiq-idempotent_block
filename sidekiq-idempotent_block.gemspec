# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/idempotent_block/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-idempotent_block"
  spec.version       = Sidekiq::IdempotentBlock::VERSION
  spec.authors       = ["Tero Tasanen"]
  spec.email         = ["tero.tasanen@gmail.com"]

  spec.summary       = %q{Sidekiq Idempotent Blcok}
  spec.description   = %q{Specify blocks in your Sidekiq workers that are run only once and skipped if the same job is retried in case of error in later stage of the worker}
  spec.homepage      = "https://github.com/ttasanen/sidekiq-idempotent_block"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'sidekiq', '>= 5.0.0', '< 5.1.0'
end
