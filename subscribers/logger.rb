require_relative '../lib/redis-config'

begin
  $redis.subscribe(:ideas) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      File.open(File.expand_path('./logs/log.txt'), 'a') do |file|
        file.write("#{data["idea"]["title"]}: #{data["idea"]["description"]}\n")
      end
    end
  end
rescue Interrupt => _
  puts "Goodbye..."
end
