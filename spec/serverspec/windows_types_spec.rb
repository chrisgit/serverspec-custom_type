require 'spec_helper'

describe Serverspec::WindowsTypes do
  it 'has a version number' do
    expect(Serverspec::WindowsTypes::VERSION).not_to be nil
  end
end
