module HostedVideo
  module Providers
    class Vimeo < Base
      def self.can_parse?(url)
        url =~ /vimeo\.com\/\d{7,8}.*/
      end

      def preview
        JSON.load(open("http://vimeo.com/api/v2/video/#{self.vid}.json")).first['thumbnail_large']
      end

      private

      def vid_regex
        /(https?:\/\/)?(www\.)?vimeo\.com\/(?<id>\d{7,8}).*/
      end
    end
  end
end