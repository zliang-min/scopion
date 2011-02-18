# encoding: utf-8

module Hejia
  module Resource
    class Index < Scopion::Resource
      def posts
        M::Post.all
      end
    end
  end
end
