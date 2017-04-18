# encoding: utf-8

require 'rubygems'
require 'boxr'
require 'mechanize'

module CarrierWave
  module Storage
    # Box uploader for carrierwave
    class Box < Abstract
      # Stubs we must implement to create and save
      attr_reader :client_box

      def identifier
        @identifier.id unless @identifier.nil?
      end

      # Store a single file
      def store!(file)
        @client_box = uploader.box_client
        # if @client_box
        path_folders = uploader.store_dir.split('/')
        begin
          path_temp = path_folders[0...-1].join('/')

          folder_will_up = @client_box.folder_from_path(path_temp)
          begin
            @client_box.create_folder(path_folders.last, folder_will_up)
          rescue Boxr::BoxrError => e
          end
          folder_will_up = @client_box.folder_from_path(uploader.store_dir)
          @identifier = @client_box.upload_file(file.to_file, folder_will_up, name: uploader.filename)
          # may god have mercy on our soul
          self.uploader.model.update_column :box_id, @identifier.id
          file
        rescue Boxr::BoxrError => e
          path_folders.each_with_index do |path, index|
            if index.zero?
              begin
                @client_box.create_folder(path.to_s, Boxr::ROOT)
              rescue Boxr::BoxrError => e
                next
              end
            else
              begin
                parent = @client_box.folder_from_path(path_folders[0..index - 1].join('/').to_s)
                @client_box.create_folder(path.to_s, parent)
              rescue Boxr::BoxrError => e
                next
              end
            end
          end

          folder_will_up = @client_box.folder_from_path(uploader.store_dir)
          @identifier = @client_box.upload_file(file.to_file, uploader.store_dir)
        end
        file
      end

      # Retrieve a single file
      def retrieve!(file)
        CarrierWave::Storage::Box::File.new(
          uploader,
          config,
          uploader.store_path(file),
          box_client
        )
      end

      private

      def link_out(client_id)
        "https://account.box.com/api/oauth2/authorize?client_id=#{client_id}&redirect_uri=http%3A%2F%2Flocalhost&response_type=code"
      end

      def config
        @config ||= {}
        @config[:box_client_id] ||= uploader.box_client_id
        @config[:box_client_secret] ||= uploader.box_client_secret
        @config[:box_developer_token] ||= uploader.box_developer_token
        @config
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def initialize(uploader, config, path, client)
          @uploader = uploader
          @config = config
          @path = path
          @client = client
        end

        def url
          file_temp = @client.file_from_path(path)
          @client.download_url(file_temp, version: nil)
        end

        def to_s
          url ||= ''
        end

        def delete
          file_temp = @client.file_from_path(@path)
          begin
            @client.delete_file(file_temp, if_match: nil)
          rescue Boxr::BoxrError => e
          end
        end
      end
    end
  end
end
