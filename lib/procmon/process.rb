module Procmon
  class Process
    CONFIGURABLE_ATTRIBUTES = [
      :pid_file,
      :pid_command,
      :pid
    ]
    attr_accessor *CONFIGURABLE_ATTRIBUTES
    attr_accessor :name, :checks

    def initialize(name, checks, options={})
      @name = name
      @checks = []

      CONFIGURABLE_ATTRIBUTES.each do |attribute_name|
        self.send("#{attribute_name}=", options[attribute_name]) if options.has_key?(attribute_name)
      end

      if @pid_command.nil? or @pid_command.empty?
        @pid_command = "pidof"
      end

      if @pid.nil?
        @pid = fetch_pid
      end

      checks.each do |name, opts|
        self.add_check(name, opts)
      end
    end

    def run_checks
      @checks.each do |check|
        value = check.run(pid)
        condition_met = check.check(value)
        perform_actions(check) if condition_met
      end
    end

    def add_check(name, options)
      self.checks << ProcessConditions[name].new(options)
    end

    def perform_actions(check)
      return if check.actions.nil? or check.actions.empty?

      check.actions.each do |action|
        if action.kind_of?(Proc)
          action.call(self, check)
        elsif action.kind_of?(Class) && action.respond_to?('notify')
          notification = ProcessNotification.new(self, check)
          action.notify(notification)
        else
          warn "Don't know what to do for #{action}."
        end
      end
    end

    private
    def fetch_pid
      pid_from_command || pid_from_file
    end

    def pid_from_file
      if pid_file
        if File.exists?(pid_file)
          str = File.read(pid_file)
          str.to_i if str.size > 0
        else
          logger.warning("pid_file #{pid_file} does not exist or cannot be read")
          nil
        end
      end
    end

    def pid_from_command
      pid = %x{#{pid_command} #{@name}}.strip
      (pid =~ /\A\d+\z/) ? pid.to_i : nil
    end
  end
end
