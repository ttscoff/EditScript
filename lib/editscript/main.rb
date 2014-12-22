#!/usr/bin/env ruby
# encoding: utf-8

module EditScript

  String.send :include, Term::ANSIColor

  [Array, String].map {|c| c.send :include, ScriptingTools::ExecAvailable }


  def self.search(args)
    @status_code = 0
    @stty_save = `stty -g`.chomp
    input, config = EditScript::Config.parse(args)
    @options = config[:options]
    @editor = config[:editor]
    @search_paths = config[:search_path]

    if (input.nil? || input.empty?) && !@options[:recent]
      puts "No search term given. Use '#{File.basename(__FILE__)} -h' for help."
      self.do_exit
    else
      @search_terms = @options[:recent] ? input.join(' ') : input.join('/')
    end

    result = self.run_search

    %x{#{@editor} "#{result}"}
  end

  def self.do_exit
    unless @stty_save.nil?
      system('stty', @stty_save)
    end
    Process.exit
  end

  private

  def self.run_search
    if @options[:recent]
      puts "Searching recent files for #{@search_terms}" if @options[:debug]
      self.recent_search
    end
    puts "Searching #{@search_terms}" if @options[:debug]
    res = self.fuzzy_search
    if @options[:show]
      self.show_and_exit(res)
    end

    unless @options[:menu] # Just execute the top result
      return res[0][:path]
    else # Show a menu of results
      res = res[0..@options[:limit]] unless @options[:showall] # limit to top 10 results

      # trap('INT') { self.do_exit }

      self.results_menu(res)
      begin
        printf("Type ".green.bold + "q".cyan.bold + " to cancel, enter to edit first option".green.bold,res.length)
        while line = Readline.readline(": ", true)
          if line =~ /^[a-z]/i
            @status_code = 0
            self.do_exit
          end
          line = line == '' ? 1 : line.to_i
          if (line > 0 && line <= res.length)
            puts res[line - 1][:path] if @options[:debug]
            return res[line.to_i - 1][:path]
          else
            puts "Out of range"
          end
        end
      rescue Interrupt => e
        p e
        @status_code = 1
        self.do_exit
      end
    end
  end

  def self.show_and_exit(res)
    res.each do |match|
      if @options[:nocolor]
        printf("[%09.4f]",match[:score]) if @options[:showscores]
        puts match[:path]
      else
        printf("[%09.4f]".green,match[:score]) if @options[:showscores]
        puts match[:path].white.bold
      end
    end
    self.do_exit
  end

  def self.recent_search
    scores = @options[:showscores] ? "" : "l"
    list = %x{fasd -#{scores}ftR #{@search_terms}}.split(/\n/)
    unless @options[:only].empty?
      only_pattern = @options[:only].join("|")
      list.delete_if {|l|
        l !~ /(#{only_pattern})$/
      }
    end
    choices = []
    @search_paths.map! {|path| File.expand_path(path) }
    list.each {|path|
      @search_paths.each {|s|
        path.strip!
        if path =~ /^#{s}/
          choices.push(path)
          break
        end
      }
    }
    if choices.length == 0
      $stderr.puts "No recent matches found, switching to fuzzy file search".red.bold
      @search_terms.gsub!(/ /, '/')
    else
      if @options[:show]
        choices.map! {|c| c.white.bold } unless @options[:nocolor]
        puts choices
      else
        res = exec "#{@editor} $(echo #{Shellwords.escape(choices.join("\n"))}|fzf -m +c -1)"
        @status_code = res ? 1 : 0
      end
      exit
    end
  end

  def self.fuzzy_search
    finder = FuzzyFileFinder.new(@search_paths,50000)

    res = finder.find(@search_terms).delete_if { |file|
      %x{file "#{file[:path]}"}.chomp !~ /text/
    }

    if res.length == 0
      puts "No matching files".red.bold
      $code = 1
      exit
    elsif res.length > 1
      unless @options[:only].empty?
        only_pattern = @options[:only].join("|")
        res.delete_if {|l|
          l[:path] !~ /(#{only_pattern})$/
        }
      end
      res = res.sort {|a,b|
        a[:score] <=> b[:score]
      }.reverse
    else
      if @options[:open_single]
        res = exec %Q{#{@editor} "#{res[0][:path]}"}
        do_exit res ? 1 : 0
      end
    end
    res
  end

  def self.results_menu(res)
    counter = 1
    puts
    res.each do |match|
      display = @options[:debug] ? match[:highlighted_path] : match[:path]
      if @options[:showscores]
        printf("%2d ) ".cyan.bold, counter)
        printf("[%09.4f]".dark.white, match[:score])
        printf(" %s\n".white.bold, display)
      else
        printf("%2d ) ".cyan.bold, counter)
        printf(" %s\n".white.bold, display)
      end
      counter += 1
    end
    puts
  end

end
