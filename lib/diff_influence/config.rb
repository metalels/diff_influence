module DiffInfluence
  module Config
    require 'pathname'
    USAGE=<<-EOS
==============================================================================
[]: optional

Usage: diff_influence [Options]

 Options:

 -p --commit commit_id,commit_id   git commit id(s) uses diff (default: none)
 -p --path path,path,...           path(s) to search file (default: app,lib)
 -e --ext  extension,extension,... extension(s) to search file (default: rb)
 -g --grep                         use grep command with OS
 -d --debug                        print debugging information to console

 Feature Options:

 -o --output path                  to output file (default: STDOUT)
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
      @@commits = value.split(",").map{|v| v.chomp.strip}
    end

    def self.search_paths
      @@search_paths ||= ["app", "lib"]
    end

    def self.search_paths=(value)
      @@search_paths = value.split(",").map{|v| v.chomp.strip}
    end

    def self.search_extensions
      @@search_extensions ||= ["rb"]
    end

    def self.search_extensions=(value)
      @@search_extensionss = value.split(",").map{|v| v.chomp.strip}
    end

    def self.output
      @@output ||= nil
    end

    def self.os_grep
      @@os_grep ||= false
    end

    def self.debug
      @@debug ||= false
    end

    def self.parse_options(argv)
      while arg = argv.shift
        case arg
        when /\A--commit\z/, /\A-c\z/
          self.commits = argv.shift
        when /\A--path\z/, /\A-p\z/
          self.search_paths = argv.shift
        when /\A--ext\z/, /\A-e\z/
          self.search_extensions = argv.shift
        when /\A--output\z/, /\A-o\z/
          @@output = argv.shift
        when /\A--grep\z/, /\A-g\z/
          @@debug = true
        when /\A--debug\z/, /\A-d\z/
          @@debug = true
        when /\A--help\z/, /\A-h\z/
          self.exit_with_message 0, true
        else
          puts "unknown option #{arg}"
          self.exit_with_message 2, true
        end
      end
    end
  end
end
