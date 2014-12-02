require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md","lib/**/*.rb","bin/**/*")
  rd.title = 'editscript'
  rd.markup = 'markdown'
end

spec = eval(File.read('editscript.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

desc 'Install the gem in the current ruby'
task :install, :all do |t, args|
  args.with_defaults(:all => false)
  if args[:all] != FalseClass
    sh "rvm all do gem install pkg/*.gem"
    sh "sudo gem install pkg/*.gem"
  else
    sh "gem install pkg/*.gem"
  end
end

desc 'Install the gem in the all rubies'
task :installall do |t, args|
  Rake::Task[:install].invoke(true)
end

desc 'Development version check'
task :ver do |t|
  system "grep VERSION lib/#{spec.name}/version.rb"
end

desc 'Bump incremental version number'
task :bump, :type do |t, args|
  args.with_defaults(:type => "inc")
  version_file = "lib/#{spec.name}/version.rb"
  raise "File not found" unless File.exists? version_file
  content = IO.read(version_file)
  content.sub!(/VERSION = '(\d+)\.(\d+)\.(\d+)(\.\S+)?'/) {|m|
    major = $1.to_i
    minor = $2.to_i
    inc = $3.to_i
    pre = $4

    case args[:type]
    when /^maj/
      major += 1
      minor = 0
      inc = 0
    when /^min/
      minor += 1
      inc = 0
    else
      inc += 1
    end

    $stdout.puts "At version #{major}.#{minor}.#{inc}#{pre}"
    "VERSION = '#{major}.#{minor}.#{inc}#{pre}'"
  }
  File.open(version_file, 'w+') {|f|
    f.puts content
  }
end

def alias_task(tasks)
    tasks.each do |new_name, old_name|
        task new_name, [*Rake.application[old_name].arg_names] => [old_name]
    end
end

alias_task [
    [:i, :install],
    [:ia, :installall],
    [:p, :package],
    [:c, :clobber]
]


task :build => [:package]
task :default => [:clobber,:rdoc,:package]
