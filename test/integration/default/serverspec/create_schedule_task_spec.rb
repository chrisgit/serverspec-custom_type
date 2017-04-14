require 'spec_helper'

describe schedule_task('TestTask') do
  its(:exist?) { should be true }
  its(:taskname) { should match 'TestTask' }
  its(:task_to_run) { should match '' }
  its(:author) { should match 'VAGRANT-2012-R2\\vagrant' }
  its(:run_as_user) { should match 'vagrant' }
end
