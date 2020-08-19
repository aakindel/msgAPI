class Message < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    has_many :message_hashtags
    has_many :hashtags, through: :message_hashtags
end
