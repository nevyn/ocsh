#!/usr/bin/env ruby
require 'irb'
require 'pp'

def method_missing(*stuff)
  return Kernel::method_missing(*stuff) if system("which #{stuff[0]} > /dev/null") != true
  return `#{stuff.join " "}`.split "\n"
end

module IRB
  class Irb
    def prompt(prompt, ltype, indent, line_no)
      time = Time.new.strftime("%H:%M:%S")
      user = whoami[0]
      wd = basename Dir.getwd
      wd = "~" if Dir.getwd == ENV["HOME"]
      
      "\033[46m#{time} #{user}:#{wd}#{ltype and ltype or "$"}\033[0m " + " "*indent
    end
  end
end

def cd where
  Dir.chdir(where)
end

def p *a
  puts *a
end


load "~/.ocshrc" if File.exists? "#{ENV["HOME"]}/.ocshrc"

IRB.start