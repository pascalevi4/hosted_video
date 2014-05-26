module HostedVideo
  module Providers
    class YoutubeByIframe < Base

      def self.can_parse?(url)
        url =~ /youtube\.com\/embed\/[\w,-]{11}(\?.*)?/
      end

      def preview
        "http://img.youtube.com/vi/#{vid}/hqdefault.jpg"
      end

      def url_for_iframe
        "http://www.youtube.com/embed/#{vid}?wmode=transparent"
      end

      private

      def vid_regex
        /youtube\.com\/embed\/(?<id>[\w,-]{11})(\?.*)?/
      end
    end
  end
end