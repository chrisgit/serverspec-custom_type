ServerSpec Custom Types
=======================

Serverspec is a tool that can be used in conjuntion with test kitchen to perform integration tests after a Chef (or other provisioner) run.

Serverspec has a rich set of resources out of the box (link: http://serverspec.org/resource_types.html).

If there isn't a resource to suit your needs you can fall back to a generic command resource to run any command.

The command resource type is useful but there is a compromise in the readability of the tests, in order to make the tests easier to read you can create your own custom types. 

This cookbook demonstrates adding a custom type (to test Windows schedule tasks) by extending the command resource type.

Requirements
------------
A cookbook built to use Test Kitchen / Chef / Serverspec.

Usage
-----
Add this cookbook to your berksfile

````
cookbook 'custom_type',  git: 'https://github.com/chrisgit/serverspec-custom_type'
````

Or download the source and set the path in the Berksfile
````
cookbook 'custom_type',  path: 'path_to_file'
````

Add the cookbook to the run list of the test suites.
````
run_list: ["recipe[custom_type]","recipe[your_cookbook]"]
````

Add your schedule task to your cookbook / recipe
````
windows_task 'chef-client' do
  user windows_username
  password windows_username_password
  cwd 'C:\\chef\\bin'
  command 'chef-client -L C:\\tmp\\'
  run_level :highest
  frequency :minute
  frequency_modifier 45
end
````

In your Serverspec spec_helper file add a reference to the custom types file(s)
````
require 'c:/serverspec/custom/schedule_task.rb
````

Or for multiple custom types
````
Dir['c:/serverspec/custom/*.rb'].each {|f| require f}
````

Contributing
------------
Fork or branch this cookbook, add code (and tests where applicable), issue pull request.

License and Authors
-------------------
Authors: Chris Sullivan
