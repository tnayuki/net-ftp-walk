# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "net-ftp-walk"
  spec.version       = "1.0.2"
  spec.authors       = ["Toru Nayuki"]
  spec.email         = ["tnayuki@icloud.com"]
  spec.summary       = "walks a FTP directory, also supports \"du\" and mirroring"
  spec.homepage      = "https://github.com/tnayuki/net-ftp-walk/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-ftp-list"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
