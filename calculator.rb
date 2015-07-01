# The Calculator class is in charge of all the calculations related to response
# times and dynos statistics
class Calculator

  def initialize(analytics)
    @analytics = analytics
    # Sorting the array of response times is required to calculate the median value
    @analytics[:response_times].sort!
  end

  def response_times_length
    @response_times_length ||= @analytics[:response_times].length
  end

  def average
    @analytics[:response_times].inject(:+).to_f / response_times_length
  end

  def median
    @analytics[:response_times][response_times_length / 2]
  end

  def modal
    # Count the occurences of each response time by using a hash
    times_with_count = @analytics[:response_times].each_with_object(Hash.new(0)) { |t, hash| hash[t] += 1 }
    @analytics[:response_times].max_by { |v| times_with_count[v] }
  end

  # Returns the dyno in the format ['dyno_name', count]
  def dyno
    @dyno ||= @analytics[:dynos].max_by {|name, count| count }
  end

  def dyno_name
    dyno ? dyno[0] : nil
  end

  def dyno_count
    dyno ? dyno[1] : nil
  end

end
