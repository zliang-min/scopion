# encoding: utf-8
# @author 梁智敏

require 'bundler'
Bundler.setup

$:.unshift File.expand_path('..', __FILE__)

require 'thin'

module Hejia
  module Model
    require 'mongoid'

    require 'model/post'
  end

  module Resource
    %w[list show form create update].each { |res|
      require "resources/post/#{res}"
    }
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
