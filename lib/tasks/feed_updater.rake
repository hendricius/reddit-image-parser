desc "This task is called by the Heroku scheduler add-on"
task :feed_updater => :environment do
  puts "Updating feed..."
  before_count = Image.count
  data = Image.update_feed
  after_count = Image.count
  if data
    puts "Successfully parsed the feed. We had #{before_count} entries, now: #{after_count}"
  else
    puts "There has been an error in updating the feed."
  end
end
