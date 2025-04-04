# frozen_string_literal: true

require 'spec_helper'

describe 'victoriametrics::vmutils' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with defaults' do
        it do
          is_expected.to contain_class('Victoriametrics::Params')
        end
        it do
          is_expected.to contain_archive('/tmp/vmutils-linux-amd64-v1.114.0-cluster.tar.gz').
            with_user('root').
            with_group('root').
            with_extract_path('/opt/victoriametrics/bin').
            with_source('https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.114.0/vmutils-linux-amd64-v1.114.0-cluster.tar.gz')
        end
      end
    end
  end
end
