require "epubdiff/version"
require 'optparse'
require 'tmpdir'
require 'fileutils'

module Epubdiff
  extend self

  def execute(*args)

    tmpdir = Dir.tmpdir
    diff_path = "diff"
    unzip_path = "unzip"

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: epubdiff [options] [filename] [filename]\n"

      opts.on('-t','--tmpdir DIR', 'Set tepmorary directory') do |dir|
        tmpdir = dir
      end

      opts.on('--diff-command PATH', 'Specify diff command path') do |path|
        diff_path = path
      end

      opts.on('--unzip-command PATH', 'Specify unzip command path') do |path|
        unzip_path = path
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
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

      system("#{unzip_path} #{file1} -d #{tmpdir}/file1")
      system("#{unzip_path} #{file2} -d #{tmpdir}/file2")
      system("#{diff_path}  #{tmpdir}/file1 #{tmpdir}/file2")

    rescue => e
      warn e
      puts opts
    end
  end

end
