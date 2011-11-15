$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "procmon/version"

Gem::Specification.new do |s|
  s.name        = "procmon"
  s.version     = Procmon::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Darren Dao"]
  s.email       = ["darrendao@gmail.com"]
  s.homepage    = "http://github.com/darrendao/procmon"
  s.summary     = %q{A process monitor written in Ruby. Concepts and design are based on Bluepill and God, but with emphasis on simplicity and extensibility.}
  s.description = %q{Procmon allows you to check on processes and then perform arbitary actions based on the result of the checks. For example, you can send notification when mem usage is too high, or you can restart a process if it's dead, etc. It is not meant to run as a daemon. It is designed to be invoked manually or via cron.}

  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'i18n', '>= 0.5.0'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]
  s.extra_rdoc_files = ["README"]
end

