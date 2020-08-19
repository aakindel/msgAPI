class MessageHashtag < ApplicationRecord
  belongs_to :hashtag
  belongs_to :message
end
