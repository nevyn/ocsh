#!/usr/bin/env ruby
require 'irb'
require 'pp'
require 'stringio'

def method_missing cmd, *argv
  print_to_stdout = true
  if(cmd.to_s[-1] == "_"[0])
    cmd = cmd.to_s[0...-1].intern
    print_to_stdout = false
  end
  which = `which #{cmd}`.strip
  return Kernel::method_missing(cmd, *argv) if $? != 0
  run_as_unix cmd, argv, print_to_stdout
end
alias cmd_missing method_missing


def flatten_arg arg
  if arg.class == Symbol then
    arg.to_s.length < 4 and "-"+arg.to_s or "--"+arg.to_s
  elsif arg.class == Array
    arg.map {|a| flatten_arg a }
  elsif arg.class == Hash
    arg.map do |k, v|
      [flatten_arg(k), flatten_arg(v)]
    end
  else
    s = arg.to_s
    if s.include? '*'
      s
    else
      "\"#{s}\""
    end
  end
end

def flatten_argv argv
  argv.map{ |arg| flatten_arg arg }.flatten.join(" ")
end

def run_as_unix cmd, argv, print_to_stdout
  flat_args = flatten_argv argv
  puts "#{cmd} #{flat_args}" if ENV['DEBUG'] == "YES"
  if print_to_stdout
    system("#{cmd} #{flat_args}")
    $?
  else
    `#{cmd} #{flat_args}`.split("\n")
  end
end

module IRB
  class Irb
    def prompt prompt, ltype, indent, line_no
      time = Time.new.strftime("%H:%M:%S")
      user = whoami_[0]
      wd = basename_ Dir.getwd
      wd = "~" if Dir.getwd == ENV["HOME"]
      
      "\033[46m#{time} #{user}:#{wd}#{ltype and ltype or "$"}\033[0m " + " "*indent
    end
  end
end


#required commands
def cd where
  Dir.chdir(where)
end

#convenience stuff
def p *a
  puts *a
end

class OGit
  def method_missing subcommand, *args
    cmd_missing "git", *([subcommand.to_s] + args)
  end
end
def ogit
  OGit.new
end


load "~/.ocshrc" if File.exists? "#{ENV["HOME"]}/.ocshrc"

IRB.start