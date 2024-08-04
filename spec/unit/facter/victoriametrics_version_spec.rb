# frozen_string_literal: true

require 'spec_helper'

describe 'Facter::Util::Fact' do
  before(:each) do
    Facter.clear
  end

  describe 'victoriametrics fact specs' do
    describe 'victoriametrics_version' do
      before(:each) do
        allow(Facter::Core::Execution).to receive(:which).
          with('vmstorage-prod').and_return('/opt/victoriametrics/bin/vmstorage-prod')
        allow(Facter::Core::Execution).to receive(:execute).with('vmstorage-prod -version', { on_fail: nil }).
          and_return('vmstorage-20240717-185758-tags-v1.102.0-cluster-0-g1ebd4e8e43')
      end

      it {
        expect(Facter.fact(:victoriametrics_version).value).to eql 'v1.102.0'
      }
    end
  end
end
