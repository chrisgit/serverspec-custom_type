lib = File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'version'
require 'types/firewall_rule_posh'
require 'types/firewall_rule'
require 'types/schedule_task'
require 'resources/schedule_task'
require 'resources/firewall_rule'
