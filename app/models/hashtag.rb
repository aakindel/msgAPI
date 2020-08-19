class Hashtag < ApplicationRecord
    has_many :message_hashtags
    has_many :messages, through: :message_hashtags
end
