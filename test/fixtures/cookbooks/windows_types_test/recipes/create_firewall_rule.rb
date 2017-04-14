msu_package 'Powershell 5' do
  source 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
  action :install
  notifies :reboot_now, 'reboot[PowerShellUpgradeReboot]', :immediately
end

reboot 'PowerShellUpgradeReboot' do
  reason 'Chef has upgraded the version of Powershell on your appliance. Rebooting.'
  action :nothing
end

powershell_script 'intall package provider' do
  code 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'
end


powershell_script 'intall dsc resources' do
  code 'Install-Module xNetworking -Confirm:$false -Force'
end

dsc_resource 'http firewall rule' do
  resource :xfirewall
  property :name, 'http - test'
  property :description, 'Test Connection'
  property :ensure, 'Present'
  property :direction, 'Inbound'
  property :protocol, 'TCP'
  property :localport, ['80']
end
