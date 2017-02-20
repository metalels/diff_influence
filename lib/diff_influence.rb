require "diff_influence/version"

%w(config core).each do |src_name|
  if RUBY_VERSION < "2.0.0"
    require "diff_influence/#{src_name}_1x"
  else
    require "diff_influence/#{src_name}"
  end
end
