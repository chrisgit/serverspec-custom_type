require 'serverspec'

# Set backend type
set :backend, :cmd

set :os, family: 'windows'

require 'windows_types'