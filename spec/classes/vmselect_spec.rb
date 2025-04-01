# frozen_string_literal: true

require 'spec_helper'

describe 'victoriametrics::vmselect' do
  shared_examples 'server classes' do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_class('victoriametrics::user').
        that_comes_before('Class[victoriametrics::install]')
    }

    it {
      is_expected.to contain_class('victoriametrics::install').
        that_comes_before('Class[victoriametrics::vmselect::config]')
    }

    it {
      is_expected.to contain_class('victoriametrics::vmselect::config').
        that_notifies('Class[victoriametrics::vmselect::service]')
    }

    it { is_expected.to contain_class('victoriametrics::vmselect::service') }
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
            with_path('/etc/victoriametrics/vmselect.conf').
            with_mode('0644').
            with_owner('victoriametrics').
            with_group('victoriametrics').
            with('content' => %r{httpListenAddr=0.0.0.0:8481}).
            with('content' => %r{storageNode=localhost}).
            with('content' => %r{cacheDataPath=/var/lib/victoriametrics/vmselect/cache})
        end
        it do
          is_expected.to contain_file('cache_directory').
            with_path('/var/lib/victoriametrics/vmselect/cache').
            with_mode('0751').
            with_owner('victoriametrics').
            with_group('victoriametrics')
        end

        it do
          is_expected.to contain_archive('/tmp/victoria-metrics-linux-amd64-v1.114.0-cluster.tar.gz').
            with_user('root').
            with_group('root').
            with_extract_path('/opt/victoriametrics/bin').
            with_source('https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.114.0/victoria-metrics-linux-amd64-v1.114.0-cluster.tar.gz')
        end
        it do
          is_expected.to contain_systemd__manage_unit('vmselect.service').
            with_ensure('present').
            with_enable(true).
            with_active(true).
            with_unit_entry(
              'Description' => 'VictoriaMetrics vmselect service',
              'After' => 'network.target',
              ).
            with_service_entry(
              'Type' => 'simple',
              'User' => 'victoriametrics',
              'Group' => 'victoriametrics',
              'UMask' => '0002',
              'ExecStart' => '/opt/victoriametrics/bin/vmselect-prod -envflag.enable',
              'EnvironmentFile' => '/etc/victoriametrics/vmselect.conf',
              'Restart' => 'on-failure',
              'RestartSec' => '30',
              'PrivateTmp' => true,
              'NoNewPrivileges' => true,
              'ProtectSystem' => 'full',
              'SyslogIdentifier' => 'vmselect'
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
      describe 'with specific storage_nodes values' do
        let :params do
          {
            storage_nodes: [
              'vmstorage-1:8400',
              'vmstorage-2:8400'
            ],
          }
        end

        it do
          is_expected.to contain_file('configuration_file').
            with('content' => %r{httpListenAddr=0.0.0.0:8481}).
            with('content' => %r{storageNode=vmstorage-1:8400,vmstorage-2:8400})
        end
      end
    end
  end
end
