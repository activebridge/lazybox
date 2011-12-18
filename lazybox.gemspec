# -*- encoding: utf-8 -*-
require File.expand_path("../lib/lazybox/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "lazybox"
  s.version     = Lazybox::VERSION
  s.authors     = ["Alex Galushka"]
  s.email       = ["sexmcs@gmail.com"]
  s.homepage    = "https://github.com/alex-galushka/lazybox"
  s.summary     = "Use LazyBox for popup windows with Rails"
  s.description = "This is high perfomance modal dialogs for your Rails application."
  s.platform    = Gem::Platform::RUBY

  s.files         = `git ls-files`.split("\n")
  s.require_path  = "lib"

  s.add_development_dependency "rails",   "~> 3.1"
  s.add_development_dependency "jquery-rails"
end

