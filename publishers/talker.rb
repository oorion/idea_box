require './lib/redis-config'

puts <<END
Welcome to IdeaBox
==================

END

loop do
  print '> '
  idea = STDIN.gets
  break if idea.chomp == 'exit'
  $redis.publish :ideas, { idea: idea.strip }.to_json
end
