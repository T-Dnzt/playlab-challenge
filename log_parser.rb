# The LogParser class is responsible for filling the
# analytics data by analyzing the log line.
class LogParser

  def initialize(analytics, log_line)
    @analytics = analytics
    rgx = /(?<datetime>[0-9.:T+-]*)\sheroku.*method=(?<method>.*)\spath=(?<path>.*)\shost=(?<host>.*)\sfwd="(?<fwd>.*)"\sdyno=(?<dyno>.*)\sconnect=(?<connect>\d+)ms\sservice=(?<service>\d+)ms\sstatus=(?<status>\d+)\sbytes=(?<bytes>\d+)/i
    request = log_line.match(rgx)
    # Explode the log line and get out the relevant data
    log_line_content = log_line.split(' ')
    @method = request['method']
    @url = request['path']
    @dyno = request['dyno']
    @connect = request['connect']
    @service = request['service']
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
