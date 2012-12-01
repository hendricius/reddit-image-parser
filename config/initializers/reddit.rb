# You need to set up an environment variable with RSS_FEED
$RSS_FEED =  ENV['RSS_FEED']

# Should only the remote image link be stored?
$STORE_REMOTE =  ENV['STORE_REMOTE']
if $STORE_REMOTE
  $STORE_REMOTE = true
else
  $STORE_REMOTE = false
end
