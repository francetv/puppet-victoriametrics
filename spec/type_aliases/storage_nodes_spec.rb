# frozen_string_literal: true

require 'spec_helper'

describe 'Victoriametrics::Storage_nodes' do
  describe 'valid file' do
    [
      [
        'vmstorage-1:8400',
        'vmstorage-2:8400'
      ],
      [
        '127.0.0.1:8400',
        '8.8.8.8:8400',
      ],
      [
        'www.vmstorage-1.example.com:7410',
        '127.0.0.1:8400',
      ],
      [
        'www.vmstorage-1.example.com:7410',
        '127.0.0.1',
      ],
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
end
