module HostedVideo
  module Providers
    class Base
      attr_accessor :url

      def initialize(url)
        @url = url
      end

      def kind
        self.class.name.split('::').last.downcase
      end

      def vid
        @vid ||= vid_regex.match(@url)[:id]
      end
    end
  end
end
