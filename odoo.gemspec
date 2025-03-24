require_relative "lib/odoo/version"

Gem::Specification.new do |spec|
  spec.name = "odoo"
  spec.version = Odoo::VERSION
  spec.authors = ["JD Hendrickson"]
  spec.email = ["jd@mancrates.com"]

  spec.summary = "Simple gem for interacting with the Odoo platform via JSON."
  spec.description = spec.summary
  spec.homepage = "https://www.mancrates.com/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mancrates/titan"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["{lib,sig}/**/*", "Rakefile", "CHANGELOG.md", "LICENSE.txt", "README.md"].reject { |fn| File.directory?(fn) }
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 7.1", "< 7.2"
  spec.add_dependency "resty"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
