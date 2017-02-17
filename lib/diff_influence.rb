require "diff_influence/version"
require "diff_influence/config"

if RUBY_VERSION < "1.9.0"
  require "diff_influence/core_1x"
else
  require "diff_influence/core"
end
