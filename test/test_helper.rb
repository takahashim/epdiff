# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'test/unit'

def fixtures_dir
  File.join(__dir__, 'fixtures')
end
