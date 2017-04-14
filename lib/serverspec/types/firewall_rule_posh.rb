require 'json'

module ChrisGit
  module Serverspec
    # Obtain WindowsFirewall rule using PowerShell and retrieve as JSON
    class WindowsFirewallPosh

      attr_reader :rules

      # Core select command, needs Get-NetFirewallRule piped into command
      FIREWALL_RULE_SELECTION = <<'EOF'
Select Name, DisplayName, Description, DisplayGroup, Group, Enabled, Profile, Platform, Direction, Action, EdgeTraversalPolicy, LooseSourceMapping, LocalOnlyMapping, Owner, PrimaryStatus, Status, EnforcementStatus, PolicyStoreSource, PolicyStoreSourceType,
@{Name="ApplicationFilter"; Expression={(Get-NetFirewallApplicationFilter -AssociatedNetFirewallRule $_) | Select-Object Program, Package}}, 
@{Name="AddressFilter"; Expression={(Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $_ | Select-Object LocalAddress, RemoteAddress)}},@{Name="InterfaceFilter"; Expression={(Get-NetFirewallInterfaceFilter -AssociatedNetFirewallRule $_ | Select-Object InterfaceAlias)}}, 
@{Name="InterfaceTypeFilter"; Expression={(Get-NetFirewallInterfaceTypeFilter -AssociatedNetFirewallRule $_ | Select-Object InterfaceType)}},
@{Name="PortFilter"; Expression={(Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ | Select-Object Protocol, LocalPort, RemotePort, IcmpType, DynamicTransport)}},
@{Name="ProfileDetail"; Expression={(Get-NetFirewallProfile -AssociatedNetFirewallRule $_)}},
@{Name="SecurityFilter"; Expression={(Get-NetFirewallSecurityFilter -AssociatedNetFirewallRule $_ | Select-Object Authentication, Encryption, OverrideBlockRules, LocalUser, RemoteUser, RemoteMachine)}},
@{Name="ServiceFilter"; Expression={(Get-NetFirewallServiceFilter -AssociatedNetFirewallRule $_ | Select-Object Service)}}
EOF

      def initialize(runner, name, options)
        @runner = runner
        @name = name
        @options = options
        @rules = []
        @firewall_rule_command = query_firewall_rules()
        extract_data
      end

      def stdout
        @firewall_rule_command.stdout
      end

      def stderr
        @firewall_rule_command.stderr
      end

      def exit_code
        @firewall_rule_command.exit_code
      end

      private

      def option_direction()
        @options.fetch(:direction, '')
      end

      def option_enabled()
        @options.fetch(:enabled, '')
      end

      def option_preparsed()
        @options.fetch(:preparsed, '')
      end

      def command_filter
        options = ''
        options << option_direction()
        options << option_enabled()
        options << option_preparsed()
        format("Get-NetFirewallRule -%s '%s' %s",
          options.empty? ? 'DisplayName' : 'DisplayGroup',
          @name,
          options)
      end

      def query_firewall_rules()
        # Depending on options, i.e. Inbound/Outbound, may have to change the query
        command = format('%s | %s | ConvertTo-Json -Compress', command_filter, FIREWALL_RULE_SELECTION.strip)
        @runner.run_command(command)
      end

      def convert_to_array(data)
        return [] << data unless data.is_a?(Array)
        data
      end

      def extract_data
        json_rules = convert_to_array(JSON.parse(@firewall_rule_command.stdout))
        json_rules.each do |rule|
          @rules << WindowsFirewallRule.new(rule)
        end
      end
    end
  end
end
