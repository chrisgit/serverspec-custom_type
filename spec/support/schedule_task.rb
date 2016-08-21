# Supporting methods and helpers for windows schedule task resource type tests

TASK_NOT_EXIST = 'ERROR: The system cannot find the file specified.'.freeze

CHEF_CLIENT_TASK = <<'EOF'

Folder: \
HostName:                             NEW-TAH393DDVGV
TaskName:                             \chef-client
Next Run Time:                        8/21/2016 1:12:00 PM
Status:                               Ready
Logon Mode:                           Interactive/Background
Last Run Time:                        N/A
Last Result:                          1
Author:                               vagrant_author
Task To Run:                          chef-client -L "C:\tmp\client.log"  /RU vagrant /RP vagrant /RL HIGHEST
Start In:                             N/A
Comment:                              N/A
Scheduled Task State:                 Enabled
Idle Time:                            Disabled
Power Management:                     Stop On Battery Mode, No Start On Batteries
Run As User:                          vagrant_user
Delete Task If Not Rescheduled:       Disabled
Stop Task If Runs X Hours and X Mins: 72:00:00
Schedule:                             Scheduling data is not available in this format.
Schedule Type:                        One Time Only, Minute
Start Time:                           4:12:00 PM
Start Date:                           5/22/2016
End Date:                             N/A
Days:                                 N/A
Months:                               N/A
Repeat: Every:                        0 Hour(s), 45 Minute(s)
Repeat: Until: Time:                  None
Repeat: Until: Duration:              Disabled
Repeat: Stop If Still Running:        Disabled
EOF
