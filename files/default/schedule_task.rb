# Register the schedule_task as a resource
module Serverspec::Helper::Type
  def schedule_task(name)
    Serverspec::Type::ScheduleTask.new(name)
  end
end

# Impliment the code for schedule_task
module Serverspec::Type
  class ScheduleTask < Base
    def exist?()
      command_result.exit_status == 0
     end

    # its(:taskname) { should contain 'name_of_task' } 
    def taskname()
      task_data(command_result.stdout)[:TaskName]
    end

    # its(:task_to_run) { should contain 'command' }
    def task_to_run()
      task_data(command_result.stdout)[:TaskToRun]
    end

	# Feel free to add any/all values returned from schtasks query or use the PowerShell Schedule Task commandlets
    def author()
      task_data(command_result.stdout)[:Author]
    end

	def run_as_user()
      task_data(command_result.stdout)[:RunAsUser]
    end
	
    # Generic access to all items in schtasks
    def stdout()
      command_result.stdout
    end

    private
    def command_result()
      @command_result ||= @runner.run_command("schtasks /query /fo LIST /V /tn \"#{@name}\" ")
    end

    def task_data_to_array(task_detail)
      task_detail.lines.to_a.each(&:chomp!).reject(&:empty?)
    end

    def task_array_to_hash(task_array)
      task_hash = task_array.each_with_object({}) do |item, task_hash|
        key,value = item.split(':', 2)
        key = key.gsub(' ', '').to_sym
        task_hash[key] = value.strip
      end
    end

    def task_data(task_detail)
      puts "task details"
      {} if task_detail.empty?
      @task_data ||= begin
        task_array = task_data_to_array(task_detail)
        task_array_to_hash(task_array)
      end
    end
  end
end
