# frozen_string_literal: true

require 'spec_helper'

describe 'Victoriametrics::Storage_node::Hostname' do
  describe 'valid node' do
    [
      'vmstorage-1',
      'vmstorage-1.example.com',
      'www.vmstorage-1.example.com',
      'www.vmstorage-1.example.com:7410',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      '192.168.1:8400',
      '192.168.1.1:8400',
      '192.168.1.1:',
      'vmstorage-1:',
      'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210:8400',
      '12AB::CD30:192.168.0.1:8400',
      '127.0.0.1:8400000',
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
