directory 'c:\temp' do
  recursive true
  action :create
end

cookbook_file 'c:\temp\TestTask.xml' do
  backup false
  source 'TestTask.xml'
  action :create
end

execute 'import task' do
  command 'schtasks /create /tn "TestTask" /xml "c:\temp\TestTask.xml" /RU vagrant /RP vagrant /F'
  action :run
end
