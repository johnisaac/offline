require '../lib/offline.rb'
require 'rack/test'
require 'test/unit'

class OfflineTest < Test::Unit::TestCase
  def setup
    @app = Pomo::Offline.call( nil )
  end
  
  def test_cache_method_should_work
    manifest = @app.generate({})
    generated_manifest = "CACHE MANIFEST\n/assets/application.js\n/assets/application.css\n/assets/backbone.js\n/assets/underscore.js\n/assets/date.js\n/assets/less.css\n/assets/mobile.css\n/assets/normalize.css\nNETWORK\n/\nFALLBACK\nonline.js offline.js"
    manifest = manifest.split("\n")
    manifest.pop
    manifest = manifest.join("\n")
    assert_equal generated_manifest, manifest
  end
  
  def test_generate_should_create_manifest_file_without_block
    manifest = @app.generate({})
    assert_equal manifest.split("\n")[0], "CACHE MANIFEST"
  end
  
  def test_generate_should_create_manifest_file_with_block
    manifest = @app.generate({}) do
      cache "application.css"
    end
    assert_equal manifest.split("\n")[0], "CACHE MANIFEST"
    assert_equal manifest.split("\n")[1], "application.css"
  end
end
