require_relative 'log_parser'
require_relative 'calculator'

file = File.open( 'sample.log' )

# The analytics hash holds all the information related to the stats
# we want to collect.
# It will be filled while looping through the logs.
analytics = {
  url_counts: {
    'GET /api/users/{user_id}/count_pending_messages' => { dynos: {}, response_times: [], regex: /GET \/api\/users\/\w*\/count_pending_messages/, count: 0 },
    'GET /api/users/{user_id}/get_messages' => { dynos: {}, response_times: [], regex: /GET \/api\/users\/\w*\/get_messages/, count: 0 },
    'GET /api/users/{user_id}/get_friends_progress' => { dynos: {}, response_times: [], regex: /GET \/api\/users\/\w*\/get_friends_progress/, count: 0 },
    'GET /api/users/{user_id}/get_friends_score' => { dynos: {}, response_times: [], regex: /GET \/api\/users\/\w*\/get_friends_score/, count: 0 },
    'POST /api/users/{user_id}' => { dynos: {}, response_times: [], regex: /POST \/api\/users\/\w*$/, count: 0 },
    'GET /api/users/{user_id}' => { dynos: {}, response_times: [], regex: /GET \/api\/users\/\w*$/, count: 0 }
  }
}

# Delegate the parsing of each line in the file to LogParser
file.each_line { |log_line| LogParser.new(analytics, log_line).run }

def display(url, data)
  calc = Calculator.new(data)
  p "#{url} was accessed #{data[:count]} times."
  p "Average : #{calc.average}ms --- Median: #{calc.median}ms --- Modal: #{calc.modal}ms --- Dyno: #{calc.dyno_name} (#{calc.dyno_count})"
  p '---------------------------------------'
end

# Extract and calculate the stats from the analytics object
analytics[:url_counts].each do |url, data|
  display(url, data)
end
