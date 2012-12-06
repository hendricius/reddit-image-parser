# The threshold posts need to have to be parsed.
$REDDIT_THRESHOLD = ENV['REDDIT_THRESHOLD'].to_i

# Use JSON = prefered as it will result in more updates..
# export REDDIT_JSON="http://www.reddit.com/r/funny/.json"
$REDDIT_JSON = ENV['REDDIT_JSON']

# export RSS_FEED="http://pipes.yahoo.com/pipes/pipe.run?_id=4a3af06dcba612424a858ea79dd263db&_render=rss&subreddit=funny&threshold=100"
# If you set JSON before, RSS is ignored
$REDDIT_RSS =  ENV['REDDIT_RSS']

# Set the title that should be used.
$REDDIT_TITLE = ENV['REDDIT_TITLE']

# Set a slogan that should be used.
$REDDIT_SLOGAN = ENV['REDDIT_SLOGAN']

# Use google analytics. Supply your property id.
$REDDIT_ANALYTICS = ENV['REDDIT_ANALYTICS']

# Should only the remote image link be stored? If not you will download all
# the pictures and store them locally.
# export STORE_REMOTE=true
$STORE_REMOTE =  ENV['STORE_REMOTE']
if $STORE_REMOTE
  $STORE_REMOTE = true
else
  $STORE_REMOTE = false
end
