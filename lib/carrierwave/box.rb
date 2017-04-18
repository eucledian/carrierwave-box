require 'carrierwave'
require 'carrierwave/storage/box'
require 'carrierwave/box/version'

module CarrierWave
  module Uploader
    # CarrierWave Box uploader
    class Base

      add_config :box_client_id
      add_config :box_client_secret
      add_config :box_enterprise_id
      add_config :jwt_private_key_path
      add_config :jwt_private_key_password

      configure do |config|
        config.storage_engines[:box] = 'CarrierWave::Storage::Box'
      end

      def box_client
        private_key = OpenSSL::PKey::RSA.new(File.read(jwt_private_key_path), jwt_private_key_password)

        ENV['BOX_ENTERPRISE_ID'] = box_enterprise_id
        ENV['BOX_CLIENT_ID'] = box_client_id
        ENV['BOX_CLIENT_SECRET'] = box_client_secret

        response = Boxr::get_enterprise_token(private_key: private_key)
        client = Boxr::Client.new(
          response['access_token'],
          refresh_token: nil,
          client_id: box_client_id,
          client_secret: box_client_secret,
        )
      end

      def web_url(identifier)
        box_client.embed_url(identifier, show_download: true)
      end
    end
  end
end
