require '../lib/offline.rb'
require 'rack/test'
require 'test/unit'

class OfflineTest < Test::Unit::TestCase
  def setup
    @app = Pomo::Offline.call( nil )
  end
  
  def test_generate_should_create_manifest_file_without_block
    manifest = @app.generate({})
    puts manifest
  end
end
