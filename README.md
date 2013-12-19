# samplelines

A simple command line tool to take samples lines from a file or set of files.

~~~

samplelines [options] [filename(s) and/or STDIN and/or STDERR]
    -v, --version      print version info
    -h, --help         print usage information
    -p, --percent      set % chance of a line being output [trumps use of -1]
    -1, --one-in       compute odds of outputing a line as 1 out of every N
    -m, --max          return at most this many lines
    -t, --time         stop running after N seconds
    
~~~

Either `-p` or `-1` is required. Filenames (or the special strings STDIN
and STDERR) will be processed in the order you specify them.

As a convenience, `samplelines` will automatically deal with gzipped files 
that end in `.gz`

Note that there is no guarantee of output. If you give a low percentage and a small file, there's a chance nothing will be randomly chosen. 

## Examples

~~~
# Pick about 10% of the lines from bigfile.txt
samplelines -p 10 bigfile.txt

# Ditto, but get a maximum of 100 lines
samplelines -p 10 -m 10 bigfile.txt

# This time, get about one out of every 500 lines
samplelines -1 500 -m 10 bigfile.txt

# Get about 2% of the lines from a set of gzipped files
samplelines -p 2 *.txt.gz

# Ditto, but don't get more than 10_000 lines or
#  run for more than five seconds
samplelines -p 2 -t 5 -m 10000 *.txt.gz
~~~


## Installation

Add this line to your application's Gemfile:

    gem 'samplelines'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install samplelines



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
