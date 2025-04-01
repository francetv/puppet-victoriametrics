# frozen_string_literal: true

require 'spec_helper'

describe 'victoriametrics::vmagent' do
  shared_examples 'server classes' do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_class('victoriametrics::user').
        that_comes_before('Class[victoriametrics::install]')
    }

    it {
      is_expected.to contain_class('victoriametrics::install').
        that_comes_before('Class[victoriametrics::vmagent::config]')
    }

    it {
      is_expected.to contain_class('victoriametrics::vmagent::config').
        that_notifies('Class[victoriametrics::vmagent::service]')
    }

    it { is_expected.to contain_class('victoriametrics::vmagent::service') }
  end

  let(:params) do
    {
      promscrape_config: {},
      remote_write_url: 'http://10.10.10.10:8081/remote',
      promscrape_max_scrape_size: '1',
      promscrape_stream_parse: '1',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with defaults' do
        it_behaves_like 'server classes'

        it do
          is_expected.to contain_class('Victoriametrics::Params')
        end
        it do
          is_expected.to contain_user('victoriametrics').
            with_ensure('present').
            with_shell('/usr/sbin/nologin').
            that_requires('Group[victoriametrics]')
        end
        it do
          is_expected.to contain_group('victoriametrics').
            with_ensure('present').
            with_members(['victoriametrics']).
            that_comes_before('User[victoriametrics]')
        end
        it do
          is_expected.to contain_systemd__manage_unit('vmagent.service').
            with_ensure('present').
            with_enable(true).
            with_active(true).
            with_unit_entry(
              'Description' => 'VictoriaMetrics vmagent service',
              'After' => 'network.target',
              ).
            with_service_entry(
              'Type' => 'simple',
              'User' => 'victoriametrics',
              'Group' => 'victoriametrics',
              'UMask' => '0002',
              'ExecStart' => '/opt/victoriametrics/bin/vmagent-prod --promscrape.config=/etc/victoriametrics/prometheus.yaml --remoteWrite.url=http://10.10.10.10:8081/remote --promscrape.maxScrapeSize=1 --promscrape.streamParse',
              'Restart' => 'on-failure',
              'RestartSec' => '30',
              'PrivateTmp' => true,
              'NoNewPrivileges' => true,
              'ProtectSystem' => 'full',
              'SyslogIdentifier' => 'vmagent'
            ).
            with_install_entry(
              'WantedBy' => 'multi-user.target'
            )
        end
      end
    end
  end
end
