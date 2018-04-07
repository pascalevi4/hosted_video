module HostedVideo
  module Providers
    class Youtube < Base
      def self.can_parse?(url)
        url =~ /(youtube\.com\/watch\?v=)|(youtu\.be\/)/
      end

      def preview
        "https://img.youtube.com/vi/#{vid}/hqdefault.jpg"
      end

      def url_for_iframe
        "https://www.youtube.com/embed/#{vid}?wmode=transparent"
      end

      private

      def vid_regex
        /(https?:\/\/)?(www\.)?((youtube\.com)|(youtu\.be))\/(watch\?v=)?(?<id>[\w,-]{11}).*/
      end
    end
  end
end
