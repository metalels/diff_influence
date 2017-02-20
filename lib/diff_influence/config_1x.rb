module DiffInfluence
  module Config
    require 'yaml'
    require 'pathname'
    USAGE=<<-EOS
==============================================================================
[]: optional

:Usage => diff_influence [Options]

 :Options => 
 -c --commit id1,id2,...          git commit id(s) uses diff (:default => none)
 -d --dir  dir1,dir2,...          path(s) to search file (:default => app,lib)
 -e --ext  ext1,ext2,...          extension(s) to search file (:default => rb)
 -i --ignore method1,method2,...  ignore methods (:default => new, index)
 -g --grep                        use grep command with OS
 -P --print                       print config values
 -D --debug                       print debugging information to console

 Feature :Options => 
 -o --output path                 to output file (:default => STDOUT)
==============================================================================
    EOS

    def self.exit_with_message(code, usage=false, msg=nil)
      puts msg unless msg.nil?
      puts USAGE if usage
      exit code
    end

    def self.root
      @@root ||= Pathname.pwd
    end

    def self.commits
      @@commits ||= []
    end

    def self.commits=(value)
      @@commits = self.flexible_value value
    end

    def self.search_directories
      @@search_directories ||= %w(app lib)
    end

    def self.search_directories=(value)
      @@search_directories = self.flexible_value value
    end

    def self.search_extensions
      @@search_extensions ||= ["rb"]
    end

    def self.search_extensions=(value)
      @@search_extensions = self.flexible_value value
    end

    def self.output
      @@output ||= nil
    end

    def self.output=(value)
      @@output = value
    end

    def self.os_grep
      @@os_grep ||= false
    end

    def self.os_grep=(value)
      @@os_grep = value
    end

    def self.debug
      @@debug ||= false
    end

    def self.debug=(value)
      @@debug =value
    end

    def self.ignore_methods
      @@ignore_methods ||= ["new", "index"]
    end

    def self.ignore_methods=(value)
      @@ignore_methods = self.flexible_value value
    end

    def self.load_conf
      ["\.diff-influence", "#{File.expand_path("~")}/\.diff-influence"].each do |conf_file|
        if File.exist? conf_file
          puts "#{conf_file} reading..." if self.debug
          self.load_conf_file conf_file
          break
        end
      end
    end

    def self.parse_args(argv)
      while arg = argv.shift
        case arg
        when /\A--commit\z/, /\A-c\z/
          self.commits = argv.shift
        when /\A--dir\z/, /\A-d\z/
          self.search_directories = argv.shift
        when /\A--ext\z/, /\A-e\z/
          self.search_extensions = argv.shift
        when /\A--ignore\z/, /\A-i\z/
          self.ignore_methods = argv.shift
        when /\A--output\z/, /\A-o\z/
          self.output = argv.shift
        when /\A--grep\z/, /\A-g\z/
          self.os_grep = true
        when /\A--debug\z/, /\A-D\z/
          self.debug = true
        when /\A--print\z/, /\A-P\z/
          self.print
          self.exit_with_message 0, false
        when /\A--help\z/, /\A-h\z/
          self.exit_with_message 0, true
        else
          puts "unknown option #{arg}"
          self.exit_with_message 2, true
        end
      end
      true
    end

    def self.print
      yaml_obj = {
        :commits => self.commits,
        :search_directories => self.search_directories,
        :search_extensions => self.search_extensions,
        :ignore_methods => self.ignore_methods,
        :os_grep => self.os_grep,
        :debug => self.debug
      }
      yaml_obj[:output] = self.output if self.output
      puts <<-EOS
======== Diff Influence Config ========
  target :commits =>     #{self.commits.inspect}
  search :directories => #{self.search_directories.inspect}
  search :extensions =>  #{self.search_extensions.inspect}
  ignore :methods =>     #{self.ignore_methods.inspect}
  output :file =>        #{self.output}
  os grep :mode =>       #{self.os_grep}
  debug :mode =>         #{self.debug}
=======================================

>>>>> sample .diff_influence
#{YAML.dump yaml_obj}
<<<<<
      EOS
      yaml_obj = nil
    end

    private
    def self.flexible_value(value)
      case value
      when Array
        value
      when String
        value.split(",").map{|v| v.chomp.strip}
      else
        nil
      end
    end

    def self.load_conf_file(file_path)
      if settings = YAML.load_file(file_path)
        settings.each do |k, v|
          self.send "#{k}=", v
        end
      end
    rescue Errno::ENOENT
      nil
    rescue => e
      puts e if self.debug
      puts "Cant load config file #{file_path}"
      exit 1
    end

  end
end
