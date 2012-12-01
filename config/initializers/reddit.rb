# You need to set up an environment variable with RSS_FEED
# export RSS_FEED="http://pipes.yahoo.com/pipes/pipe.run?_id=4a3af06dcba612424a858ea79dd263db&_render=rss&subreddit=funny&threshold=100"
$RSS_FEED =  ENV['RSS_FEED']

# Should only the remote image link be stored?
# export STORE_REMOTE=true
$STORE_REMOTE =  ENV['STORE_REMOTE']
if $STORE_REMOTE
  $STORE_REMOTE = true
else
  $STORE_REMOTE = false
end
