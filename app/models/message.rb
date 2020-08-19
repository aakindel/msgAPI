class Message < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    has_many :message_hashtags
    has_many :hashtags, through: :message_hashtags

    # Active Record Callback for create
    after_create do
        message = Message.find_by(id: self.id)
        
        # create a hash for message's hashtags
        @tags = Hash.new 0
        message.body.split().each do |word| 
            if word.start_with?"#" 
                @tags[word] += 1
            end 
        end 

        # add each hashtag to Hashtag and add its count to MessageHashtag
        @tags.each do |key, value|
            tag_name = Hashtag.find_or_create_by(name: key.downcase.delete('#'))
            message.hashtags << tag_name
            
            tag_count = MessageHashtag.find_by(hashtag_id: tag_name.id, message_id: message.id)
            tag_count.update!(hash_count: value)
        end
    end

    # Active Record Callback for update
    after_update do
        message = Message.find_by(id: self.id)

        # retain tag ids even after message.hashtags is cleared
        tag_ids = []
        message.hashtags.each do |tag|
            tag_ids << tag.id
        end

        message.hashtags.clear

        # use tag ids to delete hashtags that message has
        tag_ids.each do |tag_id|
            # don't delete a message hashtag that is being used in another message
            unless MessageHashtag.find_by(hashtag_id: tag_id)
                Hashtag.find(tag_id).destroy
            end
        end

        # create a hash for message's hashtags
        @tags = Hash.new 0
        message.body.split().each do |word| 
            if word.start_with?"#" 
                @tags[word] += 1
            end 
        end 

        # add each hashtag to Hashtag and add its count to MessageHashtag
        @tags.each do |key, value|
            tag_name = Hashtag.find_or_create_by(name: key.downcase.delete('#'))
            message.hashtags << tag_name
            
            tag_count = MessageHashtag.find_by(hashtag_id: tag_name.id, message_id: message.id)
            tag_count.update!(hash_count: value)
        end
    end
end
