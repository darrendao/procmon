require 'procmon'

NOTIFICATION_TARGET='ddao@example.com'

notifier = Proc.new do 
  puts "I NEED TO SEND OUT AN EMAIL"
end

notifier2 = Proc.new do 
  puts "I NEED TO SEND OUT AN EMAIL 2"
end

Procmon.process("Mail") do |process|
  process.pid = 29124
  process.checks :mem_usage, :above => 100.megabytes do
    puts "I'm in your base"
  end
end

Procmon.process("Mail") do |process|
  process.checks :mem_usage, :above => 100.megabytes, :actions => [notifier, notifier2]
end

Procmon.process("Mail") do |process|
  process.checks :mem_usage, :above => 100.megabytes, :actions => [Procmon::Notifiers::Email]
end

# Would be nice if we can do this
# Procmon.process("Mail") do |process|
#  process.checks :mem_usage, :above => 100.megabytes do |action|
#    action.perform(notifier)
#    action.perform(Procmon::Notifiers::Email, 'someone@eharmony.com')
#  end
#  process.checks :mem_usage, :above => 100.megabytes, :actions => [notifier, notifier2]
#  process.checks :mem_usage, :above => 100.megabytes, :actions => [Procmon::Notifiers::Email]
#end
