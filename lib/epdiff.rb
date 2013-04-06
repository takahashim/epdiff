require "epdiff/version"
require 'optparse'
require 'tmpdir'
require 'fileutils'

module Epdiff
  extend self

  def execute(*args)

    tmpdir = Dir.mktmpdir
    diff_path = "diff"
    unzip_path = "unzip"

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

      %x("#{unzip_path}" "#{file1}" -d "#{tmpdir}/file1")
      %x("#{unzip_path}" "#{file2}" -d "#{tmpdir}/file2")

      IO.popen("'#{diff_path}' -r -u '#{tmpdir}/file1' '#{tmpdir}/file2'") do |io|
        print io.read.gsub(/#{Regexp.escape(tmpdir)}/, "")
      end

    rescue => e
      warn e
      puts opts
    end
  end

end
