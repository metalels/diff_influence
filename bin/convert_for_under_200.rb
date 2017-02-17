#!/usr/bin/env ruby

src = File.read "lib/diff_influence/core.rb"
src = src.gsub(/(\w+):\s/, ':\1 => ')
src = src.gsub(/\.lines/, '.lines.to_a')
File.write "lib/diff_influence/core_1x.rb", src
