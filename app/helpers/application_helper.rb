module ApplicationHelper
  def build_title
    if @title
      title = "#{$REDDIT_TITLE} | #{@title}"
    elsif $REDDIT_TITLE
      title = $REDDIT_TITLE
    else
      title = "Reddit rss parse"
    end
    title
  end
end
