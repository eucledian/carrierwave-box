require 'carrierwave'
require 'carrierwave/storage/box'
require 'carrierwave/box/version'

module CarrierWave
  module Uploader
    # CarrierWave Box uploader
    class Base
      attr_accessor :box_identifier

      add_config :box_client_id
      add_config :box_client_secret
      add_config :box_developer_token
      configure do |config|
        config.storage_engines[:box] = 'CarrierWave::Storage::Box'
      end

      def web_url
        # TODO: Handle expired token
        client = Boxr::Client.new(box_developer_token)
        client.embed_url(@box_identifier, show_download: true)
      end

      def to_s
        @box_identifier
      end
    end
  end
end
