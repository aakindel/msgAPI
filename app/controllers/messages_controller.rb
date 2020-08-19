class MessagesController < ApplicationController
    def index
        @messages = Message.all
    end

    def hashtags
        @find_tag = Hashtag.find_by(name: params[:name])
        @messages = @find_tag.messages
    end
  
    def new
        @message = Message.new
    end
  
    def create
        @message = Message.create(message_params)

        if @message.save
            redirect_to @message
        else
            render :new
        end
    end
  
    def show
        @message = Message.find(params[:id])
    end
  
    def edit
        @message = Message.find(params[:id])
    end
  
    def update
        @message = Message.find(params[:id])
    
        if @message.update(message_params)
            redirect_to @message
        else
            render :edit
        end
    end
  
    def destroy
        # can't use Active Record Callback for destroy 
        # because it violates foreign key constraints
        
        @message = Message.find(params[:id])

        # retain tag ids even after @message.hashtags is cleared
        tag_ids = []
        @message.hashtags.each do |tag|
            tag_ids << tag.id
        end

        @message.hashtags.clear

        # use tag ids to delete hashtags that @message has
        tag_ids.each do |tag_id|
            # don't delete a @message hashtag that is being used in another message
            unless MessageHashtag.find_by(hashtag_id: tag_id)
                Hashtag.find(tag_id).destroy
            end
        end

        @message.destroy
        redirect_to messages_path
    end
  
    private
    def message_params  
        params.require(:message).permit(:title, :body)
    end
  
  end  