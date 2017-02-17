module DiffInfluence
  module Core
    EMeth=Struct.new(:name, :type, :raw, :index)
    EMeth.class_eval do
      def initialize(attr={})
        self.name = attr[:name]
        self.type = attr[:type]
        self.raw = attr[:raw]
        self.index = attr[:index]
      end
    end

    def self.debug_log(msg)
      puts "[DEBUG] #{msg}" if DiffInfluence::Config.debug
    end

    def self.git_status
      `git status | grep modified`
    end

    def self.file_paths
      @@files ||= self.git_status.lines.to_a.map{|line| line.split.last}
    end

    def self.git_diff(file_path)
      `git --no-pager diff --no-ext-diff -U1000000 #{file_path}`
    end

    def self.search_methods(file_path)
      methods = []
      last_method = nil
      cnt = 0
      lines = self.git_diff(file_path).lines.to_a
      lines.each_with_index do |line, idx|
        if line =~ /(\s|\t|;)def/ 
          last_method = lines[idx].split("def ").last.chomp.gsub("self\.","")
          self.debug_log "Method line => #{last_method}"
        end
        case line
        when /\A\+\+\+/, /\A---/, /\Adiff/, /\Aindex/, /\A@@/
          self.debug_log "Ignore line => #{line}"
          next
        when /\A\+/, /\A\-/
          cnt += 1 if line =~ /\A\+/
          self.debug_log "idx:#{idx}, cnt:#{cnt}, #{line}"

          t = case line
              when /\A-(\s|\t)*def/
                "remove"
              when /\A\+(\s|\t)*def/
                "add"
              else
                "effect"
              end
          methods.push EMeth.new(
            :name => last_method,
            :type => t,
            :raw => line,
            :index => cnt
          )
        else
          cnt += 1
        end
      end
      self.debug_log methods.to_s
      methods
    end

    def self.os_grep(keyword="")
      DiffInfluence::Config.search_paths.each do |pd|
        puts `grep -r -E '(\\.|@)#{keyword}(\\s|\\()' #{pd}`
      end
    end

    def self.native_grep(keyword="")
      self.files.each do |file|
        File.readlines(file).each_with_index do |line, idx|
          if line =~ /(\.|@)#{keyword}(\s|\()/
            puts "#{file}:#{idx+1} #{line}"
          end
        end
      end
    end

    def self.files
      @@files ||= Dir.glob(DiffInfluence::Config.search_paths.map{|d| "#{d}/**/**.{#{DiffInfluence::Config.search_extensions.join(",")}}"})
    end

    def self.influence_search(file_path)
      searched_methods = []
      self.search_methods(file_path).each do |method|
        if method.name.nil? || method.name.empty? || searched_methods.include?(method.name)
          next
        else
          searched_methods.push method.name
        end
        puts "###  Searching method[#{method.name}] (from #{file_path}:#{method.index})"
        if DiffInfluence::Config.os_grep
          self.os_grep method.name
        else
          self.native_grep method.name
        end
        puts
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
