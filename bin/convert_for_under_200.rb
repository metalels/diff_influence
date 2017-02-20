#!/usr/bin/env ruby

%w(lib/diff_influence/core.rb lib/diff_influence/config.rb).each do |src_file|
  src = File.read src_file
  src = src.gsub(/(\w+):\s/, ':\1 => ')
  src = src.gsub(/\.lines/, '.lines.to_a')
  File.write src_file.gsub('.rb', '_1x.rb'), src
  src = nil
end
