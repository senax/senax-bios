require 'spec_helper'
describe 'bios' do

  context 'with defaults for all parameters' do
    it { should contain_class('bios') }
  end
end
