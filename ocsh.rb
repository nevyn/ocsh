#!/usr/bin/env ruby
require 'irb'
require 'pp'
require 'stringio'

def method_missing(cmd, *argv)
  argv.map! do |arg|
    if arg.class == Symbol then
      "--"+arg.to_s
    else
      arg
    end
  end
  print_to_stdout = true
  if(cmd.to_s[-1] == "_"[0])
    cmd = cmd.to_s[0...-1].intern
    print_to_stdout = false
  end
  which = `which #{cmd}`.strip
  return Kernel::method_missing(cmd) if $? != 0
  if print_to_stdout
    system("#{cmd} #{argv.join(" ")}")
  else
    `#{cmd} #{argv.join(" ")}`.split("\n")
  end
#  lines = []
#  IO.popen("#{cmd} #{argv.join(" ")}") do |pipe|
#    buf = pipe.read
#    print buf if print_to_stdout
#    parts = buf.split("\n")
#    if lines.length == 0
#      lines = parts 
#    else
#      lines[-1] += parts[0]
#      lines += parts[1..-1]
#    end
#  end
#  lines
end

module IRB
  class Irb
    def prompt(prompt, ltype, indent, line_no)
      time = Time.new.strftime("%H:%M:%S")
      user = whoami_[0]
      wd = basename_ Dir.getwd
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