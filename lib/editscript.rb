require 'editscript/version.rb'
require 'term-ansicolor'
require 'readline'
require 'shellwords'
require 'editscript/execavailable.rb'
require 'editscript/config.rb'
require 'editscript/main.rb'

String.send :include, Term::ANSIColor
[Array,String].map {|c| c.send :include, EditScript }
