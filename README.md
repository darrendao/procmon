# Procmon
Procmon is a process monitor written in Ruby. Concepts and design are based on Bluepill and God, but with emphasis on simplicity and extensibility.

Procmon allows you to check on processes and then perform arbitary actions based on the result of the checks. For example, you can send notification when mem usage is too high, or you can restart a process if it's dead, etc. It is not meant to run as a daemon. It is designed to be invoked manually or via cron.

## Installation
It&apos;s hosted on [rubygems.org][rubygems].

    sudo gem install procmon

## Example of how to use Procmon

```
require 'procmon'

notifier = Proc.new do
  puts "I NEED TO SEND OUT AN EMAIL"
end

notifier2 = Proc.new do
  puts "I NEED TO SEND OUT AN SMS"
end

# action can be a Proc object. You can define whatever you want to do 
Procmon.process("Mail") do |process|
  process.checks :mem_usage, :above => 100.megabytes, :actions => [notifier, notifier2]
end

# You can specify a code block as well
Procmon.process("Mail") do |process|
  process.pid = 29124
  process.checks :mem_usage, :above => 100.megabytes do
    puts "I'm in your base"
  end
end

# Using built-in email notifier
NOTIFICATION_TARGET='ddao@example.com'
Procmon.process("Mail") do |process|
  process.checks :mem_usage, :above => 100.megabytes, :actions => [Procmon::Notifiers::Email]
end

# Check if a process is alive
Procmon.process("libvirtd") do |process|
  process.checks :process_health, :status => "down" do
    puts "Oh no! My process is not running"
  end
end

# Would be nice if we can do this as well
# Procmon.process("Mail") do |process|
#  process.checks :mem_usage, :above => 100.megabytes do |action|
#    action.perform(notifier)
#    action.perform(Procmon::Notifiers::Email, 'someone@example.com')
#  end
#  process.checks :mem_usage, :above => 100.megabytes, :actions => [notifier, notifier2]
#  process.checks :mem_usage, :above => 100.megabytes, :actions => [Procmon::Notifiers::Email]
#end
```
