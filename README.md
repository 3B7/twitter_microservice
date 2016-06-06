# NR TWITTERAPP API

This is the Microservice Endpoint that fetches and saves tweets from Twitters API. 

[live site](https://whispering-ravine-24969.herokuapp.com/request_access)

To get up and running

1. bundle install
2. Make sure to have the redis server running
3. Note: the `/sidekiq` route has basic auth setup. Credentials are in `config.ru`
4. Register a twitter app and grab the necessary secrets/access tokens
5. Copy `config/sample_config.yml` into a new file called `config/config.yml`. Set your new keys from step 3.
6. Run the migrations
7. Have fun