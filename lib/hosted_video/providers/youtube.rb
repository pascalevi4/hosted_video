module HostedVideo
  module Providers
    class Youtube < Base

      def self.can_parse?(url)
        url =~ /(youtube\.com\/)|(youtu\.be)/
      end

      def preview
        "http://img.youtube.com/vi/#{vid}/hqdefault.jpg"
      end

      private

      def vid_regex
        /(https?:\/\/)?(www\.)?((youtube\.com)|(youtu\.be))\/(watch\?v=)?(?<id>[\w,-]{11}).*/
      end
    end
  end
end