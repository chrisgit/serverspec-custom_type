# Register the schedule_task as a resource
module Serverspec
  module Helper
    module Type
      def windows_firewall_rule(name, options = {})
        Serverspec::Type::WindowsFirewallRule.new(name, options)
      end
    end
  end
end

# Code for Windows Firewall Rule
# Goes against what normal ServerSpec does - string extraction and matching but more of an experiment into structured data type
module Serverspec
  module Type
    # Serverspec class with properties for testing
    class WindowsFirewallRule < Base
      def rule_count
        matching_rules.rules.length
      end

      def stdout
        matching_rules.stdout
      end

      def rules
        matching_rules.rules
      end

      private

      def matching_rules
        @rules ||= ChrisGit::Serverspec::WindowsFirewallPosh.new(@runner, @name, @options)
      end
    end
  end
end
