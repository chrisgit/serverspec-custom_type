require 'spec_helper'
require 'support/schedule_task'

set :backend, :cmd
set :os, :family => 'windows'

describe 'Serverspec::Type::ScheduleTask' do
  describe 'when task exist' do
    describe schedule_task('chef-client') do
      let(:stdout) { CHEF_CLIENT_TASK }
      let(:exit_status) { 0 }

      its(:exist?) { should be true }
      its(:taskname) { should match 'chef-client' }
      its(:task_to_run) { should match 'chef-client -L "C:\tmp\client.log"  /RU vagrant /RP vagrant /RL HIGHEST' }
      its(:author) { should match 'vagrant_author' }
      its(:run_as_user) { should match 'vagrant_user' }
      its(:stdout) { should match CHEF_CLIENT_TASK }
    end
  end

  describe 'when task does not exist' do
    describe schedule_task('does_not_exist') do
      let(:stdout) { TASK_NOT_EXIST }
      let(:exit_status) { 1 }

      its(:exist?) { should be false }
      its(:taskname) { should be nil }
      its(:task_to_run) { should be nil }
      its(:author) { should be nil }
      its(:run_as_user) { should be nil }
      its(:stdout) { should match TASK_NOT_EXIST }
    end
  end
end
