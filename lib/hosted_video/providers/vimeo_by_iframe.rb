module HostedVideo
  module Providers
    class VimeoByIframe < Vimeo
      def self.can_parse?(url)
        url =~ /player\.vimeo\.com\/video\/\d{7,8}.*/
      end

      private

      def vid_regex
        /player\.vimeo\.com\/video\/(?<id>\d{7,8}).*/
      end
    end
  end
end