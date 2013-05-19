# -*- encoding: utf-8 -*-
require 'bundler' ; Bundler.require :development, :test
require 'gigo-activerecord'
require 'minitest/autorun'
require 'logger'

ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

module GIGO
  module ActiveRecord
    class TestCase < MiniTest::Spec

      before { setup_schema ; setup_encodings }

      let(:utf8)    { Encoding::UTF_8 }
      let(:cp1252)  { Encoding::CP1252 }
      let(:binary)  { Encoding::ASCII_8BIT }
      let(:iso8859) { Encoding::ISO8859_1 }

      let(:data_utf8)    { "€20 – “Woohoo”" }
      let(:data_cp1252)  { data_utf8.encode(cp1252) }
      let(:data_binary)  { "won\x92t".force_encoding(binary) }
      let(:data_iso8859) { "Med\xEDco".force_encoding(iso8859) }

      let(:user_data_utf8) { 
        u = User.create! { |u| u.notes = {data: data_utf8} }
        User.find(u.id)
      }
      let(:user_data_cp1252) { 
        u = User.create!
        with_db_encoding(cp1252) { UserRaw.find(u.id).update_attribute :notes, {data: data_cp1252}.to_yaml }
        User.find(u.id)
      }
      let(:user_data_binary) { 
        u = User.create!
        with_db_encoding(binary) { UserRaw.find(u.id).update_attribute :notes, {data: data_binary}.to_yaml }
        User.find(u.id)
      }
      let(:user_data_iso8859) { 
        u = User.create!
        with_db_encoding(iso8859) { UserRaw.find(u.id).update_attribute :notes, {data: data_iso8859}.to_yaml }
        User.find(u.id)
      }


      private

      def setup_schema
        ::ActiveRecord::Base.class_eval do
          silence do
            connection.instance_eval do
              create_table :users, :force => true do |t|
                t.text :notes
                t.timestamps
              end
            end
          end
        end
      end

      def setup_encodings
        GIGO.encoding = utf8
        Encoding.default_internal = utf8
      end

      def with_db_encoding(encoding)
        Encoding.default_internal = encoding
        GIGO.encoding = utf8
        yield
      ensure
        setup_encodings
      end

      class User < ::ActiveRecord::Base
        serialize :notes, Hash
      end

      class UserRaw < ::ActiveRecord::Base
        self.table_name = :users
      end

      class UserGIGO < ::ActiveRecord::Base
        serialize :notes, Hash
        # serialize_gigo :notes
        self.table_name = :users
      end

    end
  end
end
