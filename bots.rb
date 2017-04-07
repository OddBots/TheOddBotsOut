require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

# Information about a particular Twitter user we know
class UserInfo
  attr_reader :username

  # @param username [String]
  def initialize(username)
    @username = username
  end
end

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  attr_accessor :original, :model, :model_path

  def configure
    self.consumer_key = '4BcuZWX9L0LGEpy6C4HHQM5JB' # The app consumer key
    self.consumer_secret 'XXXXXXXXXXXX' # The app consumer secret (redacted in this case)

    # Users to block
    self.blacklist = ['HillaryClinton'] # wew

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..3
  end

  def top100; @top100 ||= model.keywords.take(100); end
  def top20;  @top20  ||= model.keywords.take(20); end

  def on_startup
    load_model!

    scheduler.every '1h' do # Post a tweet every hour
      statement = model.make_statement(140)
      tweet(statement)
    end

  end

  def on_message(dm)
    # Reply to a DM with Mr. Rental
      statement = model.make_statement(155)
      reply(dm, 'https://www.youtube.com/watch?v=UE6cZTw95MM')
  end

  def on_follow(user)
    # Follow a user back
    # Left blank -- The bot does not follow people
  end

  def on_mention(tweet)

    delay do
      statement = model.make_statement(120)
      reply(tweet, statement) # Reply to @mentions
    end
  end

  def on_timeline(tweet) # When James posts a tweet or retweets someone

    delay do
      statement = model.make_statement(120)
      reply(tweet, statement) # Reply to that tweet
    end
  end

  private
  def load_model!
    return if @model

    @model_path ||= "model/#{original}.model"

    log "Loading model #{model_path}"
    @model = Ebooks::Model.load(model_path)
  end
end

# Defines the bot account - Prevents any random person from using the app
MyBot.new("theoddbotsout") do |bot|
  bot.access_token = "XXXXXXXXXXXXXXXX" # @theoddbotsout's access token (redacted too)
  bot.access_token_secret = "XXXXXXXXXXXXXXXXXX" # Secret token (redacted in this case)

  bot.original = "theodd1sout" # Defines who the bot is basing themselves on
end
