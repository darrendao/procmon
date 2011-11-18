module Procmon
  # Copied from Bluepill code
  module System
    extend self

    # The position of each field in ps output
    IDX_MAP = {
      :pid => 0,
      :ppid => 1,
      :pcpu => 2,
      :rss => 3
    }

    def store
      @store ||= Hash.new
    end

    def pid_alive?(pid)
      begin
        ::Process.kill(0, pid)
        true
      rescue Errno::ESRCH
        false
      end
    end

    def memory_usage(pid)
      ps_axu[pid] && ps_axu[pid][IDX_MAP[:rss]].to_f
    end

    def cpu_usage(pid)
      ps_axu[pid] && ps_axu[pid][IDX_MAP[:pcpu]].to_f
    end 

    def ps_axu
      # TODO: need a mutex here
      store[:ps_axu] ||= begin
        # BSD style ps invocation
        lines = `ps axo pid,ppid,pcpu,rss`.split("\n")

        lines.inject(Hash.new) do |mem, line|
          chunks = line.split(/\s+/)
          chunks.delete_if {|c| c.strip.empty? }
          pid = chunks[IDX_MAP[:pid]].strip.to_i
          mem[pid] = chunks
          mem
        end
      end
    end
  end
end
