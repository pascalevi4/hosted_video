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

      def iframe_code(attributes = {})
        attrs = default_iframe_attributes.merge(attributes)
        "<iframe #{attrs.map { |key, val| "#{key}='#{val}'" }.join(' ')} src='#{url_for_iframe}'></iframe>"
      end

      private

      def default_iframe_attributes
        {
          width: 420,
          height: 315,
          frameborder: 0
        }
      end
    end
  end
end
