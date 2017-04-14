ServerSpec Custom Types
=======================

Serverspec is a tool that can be used in conjuntion with test kitchen to perform integration tests after a Chef (or other provisioner) run.

Serverspec has a rich set of resources out of the box (link: http://serverspec.org/resource_types.html).

If there isn't a resource to suit your needs you can fall back to a generic command resource to run any command.

The command resource type is useful but there is a compromise in the readability of the tests, in order to make the tests easier to read you can create your own custom types. 

This code demonstrates adding custom types by extending the command resource type.

Demo
----

Run test kitchen test or verify to see the demo

Develop
-------

Code is contained in the lib/serverspec folder and is tested with rspec.
If you make changes to the code in lib/serverspec you can create a gem and deploy it as part of the serverspec suite or use rake to copy the code to the demo cookboo (with rake update_cookbook).

All Rake tasks can be viewed with rake -AT

Contributing
------------
Fork or branch this cookbook, add code (and tests where applicable), issue pull request.

License and Authors
-------------------
Authors: Chris Sullivan

MIT - see the accompanying [LICENSE](https://github.com/chrisgit/serverspec-custom_type/blob/master/LICENSE) file for details.
