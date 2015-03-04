# Growler Alerts

Get alerts for new growler fills at [Clapton Craft](http://www.claptoncraft.co.uk/) by SMS.

## How to use

Clone the repository and bundle install

```shell
$ git clone https://github.com/philnash/growler_alerts.git
$ cd growler_alerts
$ bundle install
```

Copy `config/env.yml.example` to `config/env.yml` and fill in the keys with your [Twilio](https://www.twilio.com) credentials, a [Twilio number that can send SMS messages](https://www.twilio.com/user/account/phone-numbers/incoming) and your own phone number.

Run `rake beers:setup` to set up and load the initial set of beers into the database.

Periodically run `rake beers:alert` to check the Clapton Craft growler selection and send you an SMS when there is an update. You can run this periodically by cron or something similar. I like to do so with the Heroku Scheduler

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Once you deploy, you still need to set up the Heroku scheduler. I have set it to run every hour. The script you need to run is:

```
bundle exec rake beers:alert
```
