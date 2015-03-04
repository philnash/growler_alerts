require "redis"

class Cellar
  def initialize(type, redis=Redis.new)
    @type = type
    @redis = redis
  end

  def current_beers
    @redis.smembers("#{@type}:current")
  end

  def previous_beers
    @redis.smembers("#{@type}:previous")
  end

  def current_beers=(latest_beers)
    move_to_previous(removed_beers(latest_beers))
    @redis.sadd("#{@type}:current", latest_beers)
  end

  def clear
    @redis.del("#{@type}:current")
    @redis.del("#{@type}:previous")
  end

  private

  def removed_beers(latest_beers)
    current_beers - latest_beers
  end

  def move_to_previous(beers)
    beers.each do |beer|
      @redis.smove("#{@type}:current", "#{@type}:previous", beer)
    end
  end
end
