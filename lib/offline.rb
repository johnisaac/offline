# just like rack-offline
# generate a manifest in the beginning using a method call that supplies the list of files to be cached
# 
module Pomo
  class Offline
    attr_accessor :current, :manifest
    def initialize
      @current = "CACHE"
      @manifest = []
    end
      
    def generate( options, &block)
      # block has the list of files to be included in the manifest
      # using the block, manifest is generated here
      # call the default_manifest, if there is no block
      
      @manifest = if block_given?
        Pomo::Offline.instance_eval do
          yield
        end
      else
        default_manifest
      end
      @manifest.join("\n")
    end
    
    def self.call(env)
      # this is the application manifest route
      # /application.manifest
      new
    end
    
    def method_missing( method_name, *args, &block)
      
      case method_name
      when :cache
        unless @current == "CACHE"
          @manifest << "CACHE"
          @current = "CACHE" 
        end
        @manifest << args[0]
      when :network
        unless @current == "NETWORK"
          @current = "NETWORK" 
          @manifest << "NETWORK"
        end  
        @manifest << args[0]
      when :fallback
        unless @current == "FALLBACK"
          @current = "FALLBACK" 
          @manifest << "FALLBACK"
        end
        @manifest << "#{args[0]} #{args[1]}"
      else 
        super( method_name, *args, &block )
      end
      
    end
    
    private
    def default_manifest
      # if the rails version is 3.1, use the assets folder
      # else use the public folder
      # include all the images, stylesheets and javascripts
      @manifest << "CACHE MANIFEST"
      cache "/assets/application.js"
      cache "/assets/application.css"
      cache "/assets/backbone.js"
      cache "/assets/underscore.js"
      cache "/assets/date.js"
      cache "/assets/less.css"
      cache "/assets/mobile.css"
      cache "/assets/normalize.css"
      
      network "/"
      fallback "online.js","offline.js"
      @manifest << "#version #{key}"
    end
    
    def key
      Random.rand( Time.now.nsec * Time.now.nsec )
    end
  end
end