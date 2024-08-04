# frozen_string_literal: true

require 'spec_helper'

describe 'Victoriametrics::File' do
  describe 'valid file' do
    [
      {
        path: "/opt/victoriametrics/bin",
        owner: "root",
        group: "root",
        mode: "0755",
      }

    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
end
