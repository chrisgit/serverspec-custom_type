# Register the schedule_task as a resource
module Serverspec
  module Helper
    module Type
      def schedule_task(name)
        Serverspec::Type::ScheduleTask.new(name)
      end
    end
  end
end

# Code for schedule_task
module Serverspec
  module Type
    class ScheduleTask < Base

      def exist?
        task.exist?
      end

      # its(:taskname) { should contain 'name_of_task' }
      def taskname
        task.TaskName
      end

      # its(:task_to_run) { should contain 'command' }
      def task_to_run
        task.TaskToRun
      end

      # Feel free to add any/all values returned from schtasks query
      # Alternatively use the PowerShell Schedule Task commandlets
      def author
        task.Author
      end

      def run_as_user
        task.RunAsUser
      end

      # Generic access to all items in schtasks
      def stdout
        task.stdout
      end

      private

      def task()
        @task_data ||= ChrisGit::Serverspec::ScheduleTask.new(@runner, @name)
      end
    end
  end
end
