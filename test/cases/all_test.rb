# -*- encoding: utf-8 -*-
require 'test_helper'

module GIGO
  module ActiveRecord
    class AllTest < TestCase

      describe 'gigo_coder_for' do

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
        let(:seralized_data_iso8859_gigo)  { with_db_encoding(iso8859) { UserGIGO.find(user_data_iso8859.id).notes[:data] } }

        it 'allows dual calls' do
          UserWithDualGIGO
        end

        it 'can setup different DB data in other encodings so other test assumptions work' do
          seralized_data_utf8_raw.encoding.must_equal     utf8
          seralized_data_cp1252_raw.encoding.must_equal   cp1252
          seralized_data_binary_raw.encoding.must_equal   binary
          seralized_data_iso8859_raw.encoding.must_equal  iso8859
        end

        it 'can properly encode serialized data' do
          seralized_data_utf8_gigo.must_equal     "€20 – “Woohoo”"
          seralized_data_cp1252_gigo.must_equal   "€20 – “Woohoo”"
          seralized_data_binary_gigo.must_equal   "won’t"
          seralized_data_iso8859_gigo.must_equal  "Medíco"
        end

        it 'allows serialized attribute to still work with nil/defaults' do
          user = UserGIGO.new
          user.notes.must_equal Hash.new
          user.save
          user.reload.notes.must_equal Hash.new
        end

        it 'allows serialized attribute to still work as normal' do
          user = UserGIGO.new
          user.notes[:foo] = 'bar'
          user.save
          user.reload.notes[:foo].must_equal 'bar'
        end

      end

      describe 'gigo_column' do

        before { user_subject_binary }

        let(:id)   { user_subject_binary.id }
        let(:user) { UserGIGO.find(id) }
        let(:user_without_subject) { UserGIGOWithSuperSubject.find(id) }

        it 'hooks into GIGO' do
          user.subject.must_equal "won’t"
        end

        it 'allows user to further refine #subject method via super' do
          user_without_subject.subject.must_equal "WON’T"
        end

        it 'handles missing attributes errors gracefully for lean model selects' do
          UserGIGOWithSuperSubject.select(:id).find(id).subject.must_be_nil
        end

      end

      describe 'gigo_columns' do

        it 'converts all columns' do
          LegacyAll.gigo_columns
          assert LegacyAll::GIGOColumns.method_defined?(:subject)
          assert LegacyAll::GIGOColumns.method_defined?(:body)
          assert LegacyAll::GIGOColumns.method_defined?(:data)
        end

        it 'converts all but specified columns' do
          LegacySome.gigo_columns :data
          assert LegacySome::GIGOColumns.method_defined?(:subject)
          assert LegacySome::GIGOColumns.method_defined?(:body)
          refute LegacySome::GIGOColumns.method_defined?(:data)
        end

      end

    end
  end
end
