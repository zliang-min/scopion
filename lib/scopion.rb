# encoding: utf-8
# @auther 梁智敏 gimi<dot>liang<at>gmail<dot>com

require 'mustache'
require 'http_router'

module Scopion

  class HaltedResponse; end

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
