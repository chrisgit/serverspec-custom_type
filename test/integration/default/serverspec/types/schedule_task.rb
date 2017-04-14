module ChrisGit
  module Serverspec
    class ScheduleTask
       # Should be in alphabetical order as match condition is based on start_with?
      KEYS = [
                "Folder",
                "HostName",
                "TaskName",
                "Next Run Time",
                "Status",
                "Logon Mode",
                "Last Run Time",
                "Last Result",
                "Author",
                "Task To Run",
                "Start In",
                "Comment",
                "Scheduled Task State",
                "Idle Time",
                "Power Management",
                "Run As User",
                "Delete Task If Not Rescheduled",
                "Stop Task If Runs X Hours and X Mins",
                "Schedule Type",
                "Schedule",
                "Start Time",
                "Start Date",
                "End Date",
                "Days",
                "Months",
                "Repeat: Every",
                "Repeat: Until: Time",
                "Repeat: Until: Duration",
                "Repeat: Stop If Still Running"
              ]

      # Known keys, could auto generate but hard code for clarity
      attr_reader :Folder, :HostName, :TaskName, :NextRunTime, :Status, :LogonMode, :LastRunTime
      attr_reader :LastResult, :Author, :TaskToRun, :StartIn, :Comment, :ScheduledTaskState
      attr_reader :IdleTime, :PowerManagement, :RunAsUser, :DeleteTaskIfNotRescheduled
      attr_reader :StopTaskIfRunsXHoursandXmins, :Schedule, :ScheduleType, :StartTime
      attr_reader :StartDate, :EndDate, :Days, :Months
      attr_reader :RepeatEvery, :RepeatUntilTime, :RepeatUntilDuration, :RepeatStopIfStillRunning

      def initialize(command_runner, task_name)
        @runner = command_runner
        @task_name = task_name
        @task_detail = query_task()
        extract_data
      end

      def exist?
        @task_detail.exit_status == 0
      end

      def stdout
        @task_detail.stdout
      end

      private

      def query_task
        @runner.run_command("schtasks /query /fo LIST /V /tn \"#{@task_name}\" ")
      end

      def remove_empty_lines
        @task_detail.stdout.lines.each(&:chomp!).reject(&:empty?)
      end

      def sanitise_task_key_value(key, value)
        return key.delete(' :').to_sym, value.strip
      end

      def known_key(task_item)
        key = KEYS.detect {|k| task_item.start_with?(k)}
        return nil, nil if key.nil?
        sanitise_task_key_value(key, task_item[key.length+1..-1])
      end

      def unknown_key(task_item)
        key, value = task_item.split(':')
        sanitize_task_key_value(key, value)
      end

      def task_key_value(task_item)
        key, value = known_key(task_item)
        return key, value unless key.nil?
        unknown_key(task_item)
      end

      def extract_data
        return unless exist?
        task_data = remove_empty_lines
        task_data.each do |item|
          key, value = task_key_value(item)
          instance_variable_set("@#{key}", value)
        end
      end

    end
  end
end
