# encoding: UTF-8
require 'sinatra/base'

module VScripts
  # Main API class
  class API < Sinatra::Base
    API_VERSION = 'v1 (2014-06-16)'

    set :root, File.expand_path('../../..', __FILE__)
    set :environment, :production
    set :port, 2583
    enable :sessions, :dump_errors, :show_exceptions, :method_override,
           :static, :logging

    # Sets the title
    before do
      @title = "VScripts API - #{API_VERSION}"
    end

    # Gets the index page
    show_main = lambda do
      erb :main
    end
    # @method get_all
    # Gets the index page
    get '/', &show_main

    # Sets the version header
    after do
      response['X-API-Version'] = API_VERSION
    end
  end # class API
end # module VScripts
