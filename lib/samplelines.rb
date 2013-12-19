require 'slop'
require 'samplelines/version'

class Samplelines
  
  class MultiFile
    include Enumerable
    
    attr_accessor :files, :filenames
    
    def initialize(filenames = [])
      self.filenames = filenames
      self.files = []
      if filenames.empty?
        filenames = ['STDIN']
      end
      
      filenames.each do |fn|
        case fn
        when 'STDIN'
          self.files.push $stdin
        when 'STDERR'
          self.files.push $stderr
        else
          self.files.push File.open(fn, 'r:utf-8')
        end
      end
    end
          
      
    def each
      files.each do |f|
        f.each_line {|l| yield l}
      end
    end
  end
  
  VERSION = '0.1.0'
  
  attr_accessor :options, :slop, :orig_argv, :remaining_argv, :input
  
  def initialize(argv = ARGV)
    self.orig_argv = argv.dup
    self.remaining_argv = argv
    
    self.slop = self.create_slop!
    self.options = parse_options(self.remaining_argv)
    
  end
  
  
  def execute
    if options[:version]
      $stderr.puts "Samplelines version #{Samplelines::VERSION}"
      return
    end
    
    if options[:help] or orig_argv.empty?
      $stderr.puts slop.help
      return
    end
    
    input = Samplelines::MultiFile.new(self.remaining_argv)
    picker = create_picker(options)
    max = options[:max] ? options[:max].to_i : nil
    
    timer_finished = if options[:time]
                      seconds = options[:time].to_i
                      start_time = Time.new
                      ->() { Time.new - start_time > seconds}
                    else
                      ->() { false }
                    end
    
    total = 0
    input.each do |l|
      if picker.call
        total += 1
        print l 
      end
      return if max and total == max
      return if timer_finished.call
    end
  end

  def create_picker(opts)
    if opts[:percent]
      cutoff = opts[:percent].to_i
      out_of = 100
    elsif opts[:'one-in']
      cutoff = 1
      out_of = opts[:'one-in'].to_i
    else
      raise "Samplelines must take either -p or -1"
    end
    ->() do
      rand(out_of) < cutoff
    end
  end
  
  def create_slop!
    return Slop.new(:strict=>true) do
      banner "Samplelines [options] [filename(s) and/or STDIN and/or STDERR]"

      on 'v', 'version', 'print version info'
      on 'h', 'help',    'print usage information'
      on 'p', 'percent', 'set % chance of a line being output [trumps use of -1]', :argument=>true
      on '1', 'one-in',  'compute odds of outputing a line as 1 out of every N', :argument=>true
      on 'm', 'max', 'return at most this many lines', :argument => true
      on 't', 'time', 'stop running after N seconds', :argument => true
    end
  end
  
  def parse_options(argv)

    begin
      self.slop.parse!(argv)
    rescue Slop::Error => e
      $stderr.puts "Error: #{e.message}"
      $stderr.puts "Exiting..."
      $stderr.puts
      $stderr.puts slop.help
      exit 1
    end

    return self.slop.to_hash
  end
end

