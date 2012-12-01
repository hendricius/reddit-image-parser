reddit = YAML::load(File.open("#{Rails.root.to_s}/config/reddit.yml"))

$REDDIT = reddit
