require 'spec_helper'
require './spec/support/windows_firewall'

set :backend, :cmd
set :os, :family => 'windows'

describe 'Serverspec::Type::WindowsFirewallRule' do
  describe 'Firewall Rule' do
    describe windows_firewall_rule('test') do
      let(:stdout) { WINDOWS_FIREWALL_RULE_MULTIPlE_INBOUND }
      let(:exit_status) { 0 }

      its(:rule_count) { should be 2 }
    end

    describe windows_firewall_rule('test') do
      let(:stdout) { WINDOWS_FIREWALL_RULE_MULTIPlE_INBOUND }
      let(:exit_status) { 0 }

      it 'Rule content matches' do
        expect(subject.rules[0].DisplayName).to eq 'Test'
        expect(subject.rules[0].Description).to eq 'Test Connection'
        expect(subject.rules[0].Enabled).to eq 1
        expect(subject.rules[0].Direction).to eq 1
        expect(subject.rules[0].ApplicationFilter.Program).to eq '%ProgramFiles%\\7-zip\\7z.exe'
        expect(subject.rules[0].AddressFilter.LocalAddress).to eq '192.168.0.0'
        expect(subject.rules[0].AddressFilter.RemoteAddress).to eq '192.168.255.0'
      end
    end
  end
end
