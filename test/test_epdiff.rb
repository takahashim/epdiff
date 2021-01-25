require 'test_helper'
require 'epdiff'

class EpdiffTest < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_ezpdiff_execute_color
    out = STDOUT
    $stdout = StringIO.new
    begin

      Epdiff.new.execute(File.join(fixtures_dir, 'book_orig.epub'),
                         File.join(fixtures_dir, 'book_image.epub'))
      result = $stdout.string
    ensure
      $stdout = out
    end
    expected = File.read(File.join(fixtures_dir, 'sample_diff0.txt'))
    assert_equal expected, result
  end

  def test_ezpdiff_execute_nocolor
    out = STDOUT
    $stdout = StringIO.new
    begin

      Epdiff.new.execute('-C',
                         File.join(fixtures_dir, 'book_orig.epub'),
                         File.join(fixtures_dir, 'book_image.epub'))
      result = $stdout.string
    ensure
      $stdout = out
    end
    expected = File.read(File.join(fixtures_dir, 'sample_diff1.txt'))
    assert_equal expected, result
  end
end
