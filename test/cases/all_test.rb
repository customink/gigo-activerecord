# -*- encoding: utf-8 -*-
require 'test_helper'

module GIGO
  module Activerecord
    class AllTest < TestCase

      let(:data_utf8)    { "€20 – “Woohoo”" }
      let(:data_cp1252)  { data_utf8.encode('CP1252') }
      let(:data_binary)  { "won\x92t".force_encoding('binary') }

      it 'works' do
        assert true
      end
      
    end
  end
end
