# encoding: utf-8

module Hejia
  module Model
    class Post
      include Mongoid::Document

      field :title
      field :body
    end
  end
end
