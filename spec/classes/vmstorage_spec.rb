# frozen_string_literal: true

require 'spec_helper'

describe 'victoriametrics::vmstorage' do
  shared_examples 'server classes' do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_class('victoriametrics::user').
        that_comes_before('Class[victoriametrics::install]')
    }

    it {
      is_expected.to contain_class('victoriametrics::install').
        that_comes_before('Class[victoriametrics::vmstorage::config]')
    }

    it {
      is_expected.to contain_class('victoriametrics::vmstorage::config').
        that_notifies('Class[victoriametrics::vmstorage::service]')
    }

    it { is_expected.to contain_class('victoriametrics::vmstorage::service') }
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
          is_expected.to contain_file('configuration_directory').
            with_ensure('directory').
            with_path('/etc/victoriametrics').
            with_mode('0751').
            with_owner('victoriametrics').
            with_group('victoriametrics')
        end
        it do
          is_expected.to contain_file('configuration_file').
            with_path('/etc/victoriametrics/vmstorage.conf').
            with_mode('0644').
            with_owner('victoriametrics').
            with_group('victoriametrics').
            with('content' => %r{httpListenAddr=0.0.0.0:8482}).
            with('content' => %r{retentionPeriod=1}).
            with('content' => %r{storageDataPath=/var/lib/victoriametrics/vmstorage})
        end
        it do
          is_expected.to contain_file('data_directory').
            with_path('/var/lib/victoriametrics/vmstorage').
            with_mode('0751').
            with_owner('victoriametrics').
            with_group('victoriametrics')
        end

        it do
          is_expected.to contain_archive('/tmp/victoria-metrics-linux-amd64-v1.102.1-cluster.tar.gz').
            with_user('root').
            with_group('root').
            with_creates('/opt/victoriametrics/.v1.102.1').
            with_extract_path('/opt/victoriametrics/.v1.102.1').
            with_source('https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.102.1/victoria-metrics-linux-amd64-v1.102.1-cluster.tar.gz')
        end
        it do
          is_expected.to contain_systemd__manage_unit('vmstorage.service').
            with_ensure('present').
            with_enable(true).
            with_active(true).
            with_unit_entry(
              'Description' => 'VictoriaMetrics vmstorage service',
              'After' => 'network.target',
              ).
            with_service_entry(
              'Type' => 'simple',
              'User' => 'victoriametrics',
              'Group' => 'victoriametrics',
              'UMask' => '0002',
              'ExecStart' => '/opt/victoriametrics/bin/vmstorage-prod -envflag.enable',
              'EnvironmentFile' => '/etc/victoriametrics/vmstorage.conf',
              'Restart' => 'on-failure',
              'RestartSec' => '30',
              'PrivateTmp' => true,
              'NoNewPrivileges' => true,
              'ProtectSystem' => 'full',
              'SyslogIdentifier' => 'vmstorage'
            ).
            with_install_entry(
              'WantedBy' => 'multi-user.target'
            )
        end
      end
      describe 'with specific bind_ip values and bind_port values' do
        let :params do
          {
            configuration_map: {
              httpListenAddr: '127.0.0.1:9999',
            }
          }
        end

        it do
          is_expected.to contain_file('configuration_file').
            with('content' => %r{httpListenAddr=127.0.0.1:9999})
        end
      end
    end
  end
end
