require 'spec_helper'

describe windows_firewall_rule('http - test') do
  its(:rule_count) { should be 1 }
end

describe windows_firewall_rule('http - test') do
  it 'Rule content matches' do
    expect(subject.rules[0].DisplayName).to eq 'http - test'
    expect(subject.rules[0].Description).to eq 'Test Connection'
    expect(subject.rules[0].Enabled).to eq 1
    expect(subject.rules[0].Direction).to eq 1
    expect(subject.rules[0].PortFilter.Protocol).to eq 'TCP'
  end
end
