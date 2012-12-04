# You need to set up an environment variable with RSS_FEED
# export RSS_FEED="http://pipes.yahoo.com/pipes/pipe.run?_id=4a3af06dcba612424a858ea79dd263db&_render=rss&subreddit=funny&threshold=100"
$REDDIT_RSS =  ENV['REDDIT_RSS']

# For using JSON. If JSON is detected, it has higher importance than RSS. Set
# the environment variables as well.
$REDDIT_JSON = ENV['REDDIT_JSON']
$REDDIT_THRESHOLD = ENV['REDDIT_THRESHOLD'].to_i

# Set the title that should be used.
$REDDIT_TITLE = ENV['REDDIT_TITLE']

# Use google analytics. Supply your property id.
$REDDIT_ANALYTICS = ENV['REDDIT_ANALYTICS']

# Should only the remote image link be stored?
# export STORE_REMOTE=true
$STORE_REMOTE =  ENV['STORE_REMOTE']
if $STORE_REMOTE
  $STORE_REMOTE = true
else
  $STORE_REMOTE = false
end
