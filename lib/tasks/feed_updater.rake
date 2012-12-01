desc "This task is called by the Heroku scheduler add-on"
task :feed_updater => :environment do
  puts "Updating feed..."
  Image.update_feed
end
