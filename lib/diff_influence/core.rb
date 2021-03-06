module DiffInfluence
  module Core
    EMeth=Struct.new(:name, :type, :raw, :index)

    def self.config
      DiffInfluence::Config
    end

    def self.debug_log(msg)
      puts "[DEBUG] #{msg}" if self.config.debug
    end

    def self.git_status
      `git status | grep modified`
    end

    def self.file_paths
      @@files ||= self.git_status.lines.map {|line|
        path = line.split.last
        case path
        when *self.config.search_directories.map{|d| /\A#{d}/}
          path
        else
          nil
        end
      }.compact
    end

    def self.git_diff(file_path)
      `git --no-pager diff --no-ext-diff -U1000000 #{self.config.commits.join(' ')} #{file_path}`
    end

    def self.search_methods(file_path)
      methods = []
      last_method = nil
      cnt = 0
      lines = self.git_diff(file_path).lines
      lines.each_with_index do |line, idx|
        method_line = line =~ /(\s|\t|;)def\s/
        if method_line
          last_method = lines[idx].split('def ').last.chomp.gsub('self.', '').gsub(/\(.*\z/, '')
          self.debug_log "Method line => #{last_method}"
        end
        case line
        when /\A\+\+\+/, /\A---/, /\Adiff/, /\Aindex/, /\A@@/
          self.debug_log "Ignore line => #{line}"
          next
        when /\A\+/, /\A\-/
          cnt += 1 if line =~ /\A\+/
          self.debug_log "idx:#{idx}, cnt:#{cnt}, #{line}"
          
          t = if method_line
                line =~ /\A\-/ ? 'remove' : 'add'
              else
                'effect'
              end

          methods.push EMeth.new(last_method,t,line,cnt)
        else
          cnt += 1
        end
      end
      self.debug_log methods.to_s
      methods
    end

    def self.os_grep(keyword='')
      self.config.search_directories.each do |pd|
        puts `grep -r -E '(\\.|@)#{Regexp.escape(keyword)}(\\s|\\()' #{pd}`
      end
    end

    def self.native_grep(keyword='')
      self.files.each do |file|
        File.readlines(file).each_with_index do |line, idx|
          if line =~ /(\.|@)#{Regexp.escape(keyword)}(\s|\()/
            puts "#{file}:#{idx+1} #{line}"
          end
        end
      end
    end

    def self.files
      @@files ||= Dir.glob(self.config.search_directories.map{|d| "#{d}/**/**.{#{self.config.search_extensions.join(',')}}"})
    end

    def self.influence_search(file_path)
      searched_methods = []
      self.search_methods(file_path).each do |method|
        if(
          method.name.nil? || method.name.empty? ||
          self.config.ignore_methods.include?(method.name) ||
          searched_methods.include?(method.name)
        )
          next
        else
          searched_methods.push method.name
        end
        puts "###  Searching method[#{method.name}] (from #{file_path}:#{method.index})"
        self.grep method.name
        puts
      end
    end

    def self.grep(method_name)
      if self.config.os_grep
        self.os_grep method_name
      else
        self.native_grep method_name
      end
    end

    def self.exec
      self.file_paths.each do |fp|
        self.influence_search fp
      end
      exit 0
    end

  end
end
