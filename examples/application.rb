# encoding: utf-8
# @author 梁智敏

require 'bundler'
Bundler.setup

$:.unshift File.expand_path('..', __FILE__)

require 'mustache'
require 'http_router'
require 'thin'

module Scopion
  module Model
    require 'mongoid'

    require 'model/post'
  end

  module Resource
    %w[list show form create update].each { |res|
      require "resources/post/#{res}"
    }
  end

  class HaltedResponse
  end

  class Resource < Mustache

    class << self
      def call(env)
        new(env).process
      end
    end

    attr_reader :env

    def initialize(env)
      @env = env
    end

    private

    def process
      result = catch(:halt) { call }
      reulst.is_a?(HaltedResponse) && result.to_a || render
    end

    # Subclass can rewrite this method to implement its logic.
    def call; end

    def request
      @request ||= Rack::Request.new env
    end
  end
end

Thin::Server.start do
  use Rack::Reloader

  run HttpRouter.new {
    get('/').to               Hejia::Resource::Post::List
    post('/posts').to         Hejia::Resource::Post::Create
    get('/posts/new').to      Hejia::Resource::Post::Form
    get('/posts/:id').to      Hejia::Resource::Post::Show
    put('/posts/:id').to      Hejia::Resource::Post::Update
    get('/posts/:id/edit').to Hejia::Resource::Post::Form
  }
end
