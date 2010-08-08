ocsh
===================

A macruby shell. Strives to be both unixy and rubyish and objcish at the same time.

**Differentiates between 'interactive' commands** (prints to stdout) and 'capturing' 
commands (returns its value as array of lines). default to interactive, as 
that's the Unix default. Run command as "capture" by suffixing underscore: _.

<pre><code>10:35:04 nevyn:ocsh$ ls
ocsh.rb        README.md
=> true
10:35:06 nevyn:ocsh$ ls_
=> ["ocsh.rb", "README.md"]
</code></pre>


**Unixifies rubyish arguments**.

<pre><code>git 'commit', :m => "Refactor and do more fancy stuff with args"
git 'commit', :amend
</code></pre>

:m becomes -m, :foobar becomes --foobar.

**Config file** is at ~/.ocshrc. Just type ruby in it. ocsh is just irb with a method_missing, so ~/.irbrc will be run too, after ocsrc.