# The LogParser class is responsible for filling the
# analytics data by analyzing the log line.
class LogParser

  def initialize(analytics, log_line)
    @analytics = analytics

    # Explode the log line and get out the relevant data
    log_line_content = log_line.split(' ')
    @method = log_line_content[3].gsub('method=', '')
    @url = log_line_content[4].gsub('path=', '')
    @dyno = log_line_content[7].gsub('dyno=', '')
    @connect = log_line_content[8].gsub('connect=', '').gsub('ms', '')
    @service = log_line_content[9].gsub('service=', '').gsub('ms', '')
  end

  def run
    # Attempt to find a match in our list of regex
    @analytics[:url_counts].each do |route, data|
      if data[:regex].match("#{@method} #{@url}")
        data[:count] += 1
        data[:response_times] << @connect.to_i + @service.to_i
        data[:dynos][@dyno] ||= 0
        data[:dynos][@dyno] += 1
        break
      end
    end
  end

end
