module HostedVideo
  module Providers
    class YoutubeByIframe < Youtube
      def self.can_parse?(url)
        url =~ /youtube\.com\/embed\/[\w,-]{11}(\?.*)?/
      end

      private

      def vid_regex
        /youtube\.com\/embed\/(?<id>[\w,-]{11})(\?.*)?/
      end
    end
  end
end