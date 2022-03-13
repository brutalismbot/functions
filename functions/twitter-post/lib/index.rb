require 'yake'
require 'yake/support'

TWITTER ||= Twitter::Brutalismbot.new

handler :twitter_post do |event|
  TWITTER.post(**event.symbolize_names)
end
