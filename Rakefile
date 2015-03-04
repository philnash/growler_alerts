require "rake/testtask"
begin
  require "envyable"
rescue LoadError
end
require "twilio-ruby"
require "./lib/clapton_craft"
require "./lib/cellar"

if defined? Envyable
  Envyable.load("./config/env.yml")
end

ENV["REDIS_URL"] ||= ENV["REDISTOGO_URL"]

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList["spec/*_spec.rb"]
  t.verbose = true
  t.name = :spec
  t.description = "Run specs for growler alerts"
end

task default: :spec

namespace :beers do
  desc "Loads initial set of beers into Redis"
  task :setup do
    redis = Redis.new(url: ENV["REDIS_URL"])
    clapton_craft = ClaptonCraft.new("./spec/fixtures/clapton_craft.html")
    [:growlers, :bottles].each do |type|
      cellar = Cellar.new(type, redis)
      cellar.current_beers = clapton_craft.send(type)
    end
  end

  desc "Gets latest beers and sends me an SMS if there are new ones"
  task :alert do
    client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
    redis = Redis.new(url: ENV["REDIS_URL"])
    clapton_craft = ClaptonCraft.new("./spec/fixtures/clapton_craft_new.html")
    [:growlers, :bottles].each do |type|
      cellar = Cellar.new(type, redis)
      latest_beers = clapton_craft.send(type)
      new_beers = latest_beers - cellar.current_beers
      if new_beers.any?
        client.messages.create(
          from: ENV["TWILIO_NUMBER"],
          to: ENV["MY_NUMBER"],
          body: "New #{type} at Clapton Craft: #{new_beers.join(", ")}"
        )
        cellar.current_beers = latest_beers
      end
    end
  end

  desc "Clears out all cellars"
  task :clear do
    redis = Redis.new(url: ENV["REDIS_URL"])
    [:growlers, :bottles].each do |type|
      cellar = Cellar.new(type, redis)
      cellar.clear
    end
  end
end
