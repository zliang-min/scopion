# encoding: utf-8
# @author Gimi Liang

module Resource
  module Renderable
    def self.append_features(mod)
      mod.extend ClassMethods
    end

    module ClassMethods
      def self.extended(mod)
        class << mod
          protected

          attr_reader :render_logic
        end
      end

      # define render logic.
      # @yield this block will be called under the context of a renderable object instance.
      def render
        @render_logic = Proc.new if block_given?
      end

      def inherited(klass)
        super
        klass.render &self.render_logic
      end
    end

    def render
      instance_eval &self.class.render_logic
    end
  end

  module Rackish
    def self.append_features(mod)
    end

    module ClassMethods
      def self.extended(mod)
        class << mod
          protected

          attr_reader :rack_call_proc
        end
      end

      def call(env = nil)
        if env
          new(env).call
        else
          @rack_call_proc = Proc.new if block_given?
        end
      end

      private

      def inherited(klass)
        super
        klass.call &self.rack_call_proc
      end
    end

    def initialize(env)
      @env = env
    end

    def call
      instance_eval &self.class.rack_call_proc
    end

    private

    attr_reader :env

    def request
      @request ||= Rack::Request.new env
    end

    def response
      @response ||= Rack::Response.new
    end
  end

  module Collection
    class Base
      include Renderable
      include Rackish

      render do
      end

      call do
      end
    end

    class Auto < Base
    end

    class Manaul < Base
    end
  end

  class File
    include Renderable
    include Rackish
  end

  class Page < File
  end

  class Layout < Page
  end

  class Partial < Page
  end

  class Image < File
  end

  class Css < File
  end

  class Javascript < File
  end

  class AdobeFlash < File
  end
end
