module Procmon
  def self.process(proc_name, options = {}, &block)
    proc_fact = ProcessFactory.new(proc_name, options, block)
    process = proc_fact.create_process
    process.run_checks
  end
end
