require 'optparse'
require 'optparse/time'
require 'ostruct'

unless OpenStruct.method_defined? :to_h
  class OpenStruct
    def to_h
      self.marshal_dump
    end
  end
end

module EditScript
  class Config
    # TODO: Add an rc file option in addition to environment variables
    def self.parse(args)
      defaults = {
        :editor => false, # $EDITSCRIPT_EDITOR
        :search_path => false, # $EDITSCRIPT_PATH
        :default_types => false, # $EDITSCRIPT_TYPES
        :options => {
          :ignore_only => false, # Ignore any file extension constraints
          :show => false, # Show results without executing
          :menu => true, # Don't display a menu, execute/show the highest ranked result
          :only => ENV['EDITSCRIPT_TYPES'] ? self.build_type_pattern(ENV['EDITSCRIPT_TYPES']) : [], # only show files matching extensions
          :showall => false, # Show all results, otherwise limited to top 10
          :limit => 10,
          :showscores => false, # Show match scoring with results
          :debug => false, # Verbose debugging
          :recent => false,
          :function_search => false,
          :open_single => false,
          :nocolor => false
        }
      }
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      config = OpenStruct.new({
        'editor' => defaults[:editor],
        'search_path' => defaults[:search_path],
        'options' => defaults[:options]
      })

      opt_parser = OptionParser.new do |opt|

        opt.banner = "Usage: #{File.basename(__FILE__)} [config.options] 'search terms'"
        opt.separator  ""
        opt.separator  "Options:"

        opt.on("-v", "--version", "Display version and exit") do
          ver = EditScript::VERSION
          $stdout.puts "EditScript v#{ver}"
          EditScript.do_exit
        end

        opt.on("-l","--limit X","Limit to X results") do |x|
          lim = x.to_i
          config.options[:limit] = lim > 0 ? lim - 1 : lim
        end

        opt.on("-r","--recent","Use fasd and fzf to choose recently accessed files") do
          missing = ['fzf', 'fasd'].missing_bins
          if missing.empty?
            config.options[:recent] = true
          else
            $stdout.puts "'recent' search specified, but required binaries weren't found:"
            $stdout.puts missing.join(", ")
            $stdout.puts "You can install with homebrew: 'brew install #{missing.join(" ")}'"
            $stdout.puts
            $stdout.print "Continue with standard search? Y/n: "
            res = STDIN.gets
            if res =~ /^n/i
              EditScript.do_exit
            end
          end
        end

        opt.on("-f","--function","Use grep (or silver_searcher if available) to search for files containing functions and aliases matching terms") do
          config.options[:function_search] = true
        end

        opt.on("-1","--open_single","If there's only a single match, open it immediately") do
          config.options[:open_single] = true
        end

        opt.on("-s","--show","Show results without executing") do |environment|
          config.options[:show] = true
        end

        opt.on("--nocolor","Supress color output on --show command") do
          config.options[:nocolor] = true
        end

        opt.on("-o","--only [EXTENSIONS]","Only accept files with these extensions (comma-separated). To include files with no extension, use an extra comm, e.g. '-o ,' or '-o py,rb,,'") do |exts|
          config.options[:only] = build_type_pattern(exts)
        end

        opt.on("-O", "Ignore any file extension limits in config, environment variables, or arguments") do
          config.options[:ignore_only] = true
        end

        opt.on("-n","--no-menu","No menu interaction. Executes the highest ranked result or, with '-s', returns a plain list of results") do |menu|
          config.options[:menu] = false
        end

        opt.on("-a","--show-all","Show all results, otherwise limited to top 10") do
          config.options[:showall] = true
        end

        opt.on("--scores","Show match scoring with results") do
          config.options[:showscores] = true
        end

        opt.on("-d","--debug","Verbose debugging") do
          config.options[:debug] = true
        end

        opt.on("-h","--help","help") do
          puts opt_parser
          exit
        end
      end

      opt_parser.parse!(args)

      config.editor ||= ENV['EDITSCRIPT_EDITOR'] ? ENV['EDITSCRIPT_EDITOR'] : ENV['EDITOR'] || 'vim'
      search_path_fallback = ENV['EDITSCRIPT_PATH'] ? ENV['EDITSCRIPT_PATH'] : ENV['HOME']
      config.search_path ||= search_path_fallback.split(/:/)

      p config if config.options[:debug]
      [args, config.to_h]
    end

    private

    def self.build_type_pattern(string)
      exts = string.dup
      patterns = []
      patterns.push("^.*?\/\\.?[^\\.]+") if exts =~ /(,,|,$)/
      exts.gsub!(/ *,+ */,',')
      exts.split(/,/).each {|e| patterns.push("\\." + e.sub(/^\./,'')) }
      patterns
    end
  end
end
