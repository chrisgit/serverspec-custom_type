require 'json'

module ChrisGit
  module Serverspec

    # Construct firewall rules from JSON to physical object with properties
    class MultivalueProperty
      def initialize(property_values)
        @property_values = property_values
        process_properties()
      end

      @multivalue_property_names = []
      @class_property_names = {}

      class << self
        attr_reader :multivalue_property_names
        attr_reader :class_property_names

        def multivalue_properties(*multivalue_property_names)
          @multivalue_property_names ||= []
          @multivalue_property_names += multivalue_property_names
          multivalue_property_names.each do |name|
            send(:attr_accessor, name)
            send(:attr_accessor, "#{name}Count")
          end
        end

        def class_properties(*class_property_names)
          @class_property_names ||= {}
          @class_property_names.merge!(class_property_names[0])
          class_property_names[0].each_pair do |name, _klass|
            send(:attr_accessor, name)
          end
        end
      end

      def self.inherited(subclass)
        [:multivalue_property_names, :class_property_names].each do |inherit_attribute|
          instance_var = "@#{inherit_attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end

      private

      def process_properties()
        @property_values.each_pair do |key, value|
          set_property_value(key, value)
        end
      end

      def set_property_value(key, value)
        if self.class.class_property_names.include?(key.to_sym)
          value_class(key, value)
        elsif self.class.multivalue_property_names.include?(key.to_sym)
          value_count(key, value)
        else
          instance_variable_set("@#{key}", value)
        end
      end

      def value_class(key, value)
        klass_value = self.class.class_property_names[key.to_sym].new(value)
        instance_variable_set("@#{key}", klass_value)
      end

      def value_count(key, value)
        if @property_values[key].is_a?(Hash)
          instance_variable_set("@#{key}", @property_values[key]['value'])
          instance_variable_set("@#{key}Count", @property_values[key]['Count'])
        else
          instance_variable_set("@#{key}", value)
          instance_variable_set("@#{key}Count", 1)
        end
      end
    end

    # Nested class for ApplicationFilter
    class WindowsFirewallRuleApplicationFilter < MultivalueProperty
      attr_reader :Program, :Package
    end

    # Nested class for AddressFilter
    class WindowsFirewallRuleAddressFilter < MultivalueProperty
      multivalue_properties :LocalAddress, :RemoteAddress
    end

    # Nested class for InterfaceFilter
    class WindowsFirewallRuleInterfaceFilter < MultivalueProperty
      attr_reader :InterfaceFilter
    end

    # Nested class for InterfaceTypeFilter
    class WindowsFirewallRuleInterfaceTypeFilter < MultivalueProperty
      attr_reader :InterfaceFilter
    end

    # Nested class for PortFilter
    class WindowsFirewallRulePortFilter < MultivalueProperty
      attr_reader :Protocol, :LocalPort, :RemotePort, :IcmpType, :DynamicTransport
    end

    # Nested class for SecurityFilter
    class WindowsFirewallSecurityFilter < MultivalueProperty
      attr_reader :Authentication, :Encryption, :OverrideBlockRule, :LocalUser
      attr_reader :RemoteUser, :RemoteMachine
    end

    # Nested class for ServiceFilter
    class WindowsFirewallRuleServiceFilter < MultivalueProperty
      attr_reader :Service
    end

    # Container for the entire firewall rule
    class WindowsFirewallRule < MultivalueProperty
      # Custom classes
      class_properties :AddressFilter => WindowsFirewallRuleAddressFilter, :ApplicationFilter => WindowsFirewallRuleApplicationFilter
      class_properties :InterfaceFilter => WindowsFirewallRuleInterfaceFilter, :InterfaceTypeFilter => WindowsFirewallRuleInterfaceTypeFilter
      class_properties :PortFilter => WindowsFirewallRulePortFilter, :SecurityFilter => WindowsFirewallRuleServiceFilter
      class_properties :ServiceFilter => WindowsFirewallRuleServiceFilter

      # Known keys, could auto generate but hard code for clarity
      attr_reader :Name, :DisplayName, :Description, :DisplayGroup, :Group, :Enabled, :Profile
      attr_reader :Platform, :Direction, :Action, :EdgeTraversalPolicy, :LooseSourceMapping, :LocalOnlyMapping, :Owner, :PrimaryStatus
    end
  end
end
