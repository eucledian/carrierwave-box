require 'carrierwave'
require 'carrierwave/storage/box'
require 'carrierwave/box/version'

module CarrierWave
  module Uploader
    # CarrierWave Box uploader
    class Base
      add_config :box_client_id
      add_config :box_client_secret
      add_config :box_developer_token
      configure do |config|
        config.storage_engines[:box] = 'CarrierWave::Storage::Box'
      end
    end
  end
end
