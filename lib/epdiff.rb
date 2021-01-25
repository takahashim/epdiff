require "epdiff/version"
require 'optparse'
require 'tmpdir'
require 'fileutils'
require 'zip'
require 'pastel'
require 'tty/file'


class Epdiff
  TEXT_EXT = %w(xhtml html xml opf css txt)

  def self.execute(*args)
    new.execute(*args)
  end

  def initialize
    @pastel = Pastel.new(enabled: true)
    @green = @pastel.green.detach
    @red = @pastel.red.detach
    @cyan = @pastel.cyan.detach
    @color = true
  end

  def unzip(filename, dir)
    Zip::InputStream.open(filename) do |zio|
      while entry = zio.get_next_entry
        if  entry.file?
          entry_filename = File.join(dir, entry.name)
          FileUtils.mkdir_p File.dirname(entry_filename)
          File.binwrite(entry_filename, zio.read)
        end
      end
    end
  end

  def show_diff(file1, file2, work_dir)
    Dir.chdir(work_dir) do
      files1 = Dir.glob("file1/**/*")
      files2 = Dir.glob("file2/**/*")
      files1_s = files1.map{|d| d.sub(%r{^file1/}, '')}
      files2_s = files2.map{|d| d.sub(%r{^file2/}, '')}
      files_common = files1_s & files2_s
      files_common.each do |path|
        if File.file?("file1/#{path}")
          if text_file?("file1/#{path}")
            text_diff(path, "file1/#{path}", "file2/#{path}")
          else
            binary_diff(path, "file1/#{path}", "file2/#{path}")
          end
        end
      end
      (files1_s - files2_s).each do |diff1|
        @exit_code = 1
        message = "DIFF: #{diff1} only exists in 1st.\n"
        print @color ? @red.call(message) : message
      end
      (files2_s - files1_s).each do |diff2|
        @exit_code = 1
        message = "DIFF: #{diff2} only exists in 2nd.\n"
        print @color ? @green.call(message) : message
      end
    end
  end

  def text_file?(path)
    extname = File.extname(path).sub(/\A\./, '')
    if TEXT_EXT.include?(extname)
      extname
    else
      nil
    end
  end

  def text_diff(_path, path1, path2)
    diff = @color ? TTY::File.diff(path1, path2, verbose: false) : TTY::File.diff(path1, path2, verbose: false, color: nil)
    if diff != "No differences found\n" && diff.strip != ""
      @exit_code = 1
      print diff
    end
  end

  def binary_diff(path, path1, path2)
    content1 = File.binread(path1)
    content2 = File.binread(path2)
    if content1 != content2
      @exit_code = 1
      message = "DIFF: #{path} has some differences.\n"
      print @color ? @cyan.call(message) : message
    end
  end

  def execute(*args)

    tmpdir = work_dir = nil
    diff_path = nil
    unzip_path = nil

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: epdiff [options] [filename] [filename]\n"

      opts.on('-t','--tmpdir DIR', 'Set tepmorary directory') do |dir|
        tmpdir = dir
      end

      opts.on('-h', '--help', 'Show this help message') do
        puts opts
        exit
      end

      opts.on('-C', '--no-color', 'Not use color diff') do
        @color = false
      end

      opts.on('-v', '--version', 'Show version number') do
        puts Epdiff::VERSION
        exit
      end
    end

    begin

      opts.parse!(args)

      if args.size != 2
        # invalid option
        puts opts
        exit
      end

      work_dir = tmpdir || Dir.mktmpdir

      file1, file2 = *args
      FileUtils.mkdir_p(work_dir+"/file1")
      FileUtils.mkdir_p(work_dir+"/file2")

      unzip(file1, "#{work_dir}/file1")
      unzip(file2, "#{work_dir}/file2")

      @exit_code = 0
      show_diff(file1, file2, work_dir)
      exit(@exit_code)
    rescue => e
      warn e
      puts opts
    ensure
      if work_dir && !tmpdir
        FileUtils.rm_rf(work_dir)
      end
    end
  end

end
