# frozen_string_literal: true

Facter.add(:victoriametrics_version) do
  confine { Facter::Core::Execution.which('vmstorage-prod') }
  setcode do
    version = Facter::Core::Execution.execute('vmstorage-prod -version', { on_fail: nil })
    version.match(%r{v\d+\.\d+\.\d+}).to_s if version
  end
end
