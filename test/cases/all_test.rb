# -*- encoding: utf-8 -*-
require 'test_helper'

module GIGO
  module ActiveRecord
    class AllTest < TestCase

      before { user_data_utf8 ; user_data_cp1252 ; user_data_binary ; user_data_iso8859 }

      let(:seralized_data_utf8)          { with_db_encoding(utf8) { user_data_utf8.notes[:data] } }
      let(:seralized_data_utf8_raw)      { with_db_encoding(utf8) { UserRaw.find(user_data_utf8.id).notes } }
      let(:seralized_data_utf8_gigo)     { with_db_encoding(utf8) { UserGIGO.find(user_data_utf8.id).notes[:data] } }

      let(:seralized_data_cp1252)        { with_db_encoding(cp1252) { user_data_cp1252.notes[:data] } }
      let(:seralized_data_cp1252_raw)    { with_db_encoding(cp1252) { UserRaw.find(user_data_cp1252.id).notes } }
      let(:seralized_data_cp1252_gigo)   { with_db_encoding(cp1252) { UserGIGO.find(user_data_cp1252.id).notes[:data] } }

      let(:seralized_data_binary)        { with_db_encoding(binary) { user_data_binary.notes[:data] } }
      let(:seralized_data_binary_raw)    { with_db_encoding(binary) { UserRaw.find(user_data_binary.id).notes } }
      let(:seralized_data_binary_gigo)   { with_db_encoding(binary) { UserGIGO.find(user_data_binary.id).notes[:data] } }

      let(:seralized_data_iso8859)       { with_db_encoding(iso8859) { user_data_iso8859.notes[:data] } }
      let(:seralized_data_iso8859_raw)   { with_db_encoding(iso8859) { UserRaw.find(user_data_iso8859.id).notes } }
      let(:seralized_data_iso8859_gigo)  { with_db_encoding(iso8859) { UserGIGO.find(user_data_binary.id).notes[:data] } }

      it 'can setup different DB data in other encodings so other test assumptions work' do
        seralized_data_utf8_raw.encoding.must_equal     utf8
        seralized_data_cp1252_raw.encoding.must_equal   cp1252
        seralized_data_binary_raw.encoding.must_equal   binary
        seralized_data_iso8859_raw.encoding.must_equal  iso8859
      end

      
      
    end
  end
end
