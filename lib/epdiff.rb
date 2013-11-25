require "epdiff/version"
require 'optparse'
require 'tmpdir'
require 'fileutils'
require 'zip'

module Epdiff
  extend self

  def unzip(filename, dir)
    Zip::InputStream.open(filename) do |zio|
      while (entry = zio.get_next_entry)
        entry_filename = File.join(dir, entry.name)
        FileUtils.mkdir_p File.dirname(entry_filename)
        File.open(entry_filename, "wb") do |f|
          f.write zio.read
        end
      end
    end
  end

  def execute(*args)

    tmpdir = Dir.mktmpdir
    diff_path = "diff"
    unzip_path = nil

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: epdiff [options] [filename] [filename]\n"

      opts.on('-t','--tmpdir DIR', 'Set tepmorary directory') do |dir|
        tmpdir = dir
      end

      opts.on('--diff-command PATH', 'Specify diff command path') do |path|
        diff_path = path
      end

      opts.on('--unzip-command PATH', 'Specify unzip command path') do |path|
        unzip_path = path
      end

      opts.on('-h', '--help', 'Show this help message') do
        puts opts
        exit
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

      file1, file2 = *args
      FileUtils.mkdir_p(tmpdir+"/file1")
      FileUtils.mkdir_p(tmpdir+"/file2")

      if unzip_path
        %x("#{unzip_path}" "#{file1}" -d "#{tmpdir}/file1")
        %x("#{unzip_path}" "#{file2}" -d "#{tmpdir}/file2")
      else
        unzip(file1, "#{tmpdir}/file1")
        unzip(file2, "#{tmpdir}/file2")
      end

      IO.popen("'#{diff_path}' -r -u '#{tmpdir}/file1' '#{tmpdir}/file2'") do |io|
        print io.read.gsub(/#{Regexp.escape(tmpdir)}/, "")
      end

    rescue => e
      warn e
      puts opts
    end
  end

end
