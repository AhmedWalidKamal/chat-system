class ChatsController < ApplicationController

  include Filter

  before_action :set_application
  before_action :set_chat, only: [:show, :update, :destroy]

  def index
    @chats = @application.chats.all
    render filter @chats
  end

  def show
    render filter @chat
  end

  def create
    @chat = @application.chats.build
    @chat.number = next_chat_number
    @chat.messages_count = 0

    if @chat.valid?
      ChatWorker.perform_async(@application.token, @chat.number)
      render filter @chat
    else
      render json: @chat.errors, status: :bad_request
    end
  end

  def update
    if @chat.update(chat_params)
      render filter @chat
    else
      render json: @chat.errors, status: :bad_request
    end
  end

  def destroy
    @chat.destroy
  end

  private
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end

    def set_chat
      @chat = @application.chats.find_by!(number: params[:number])
    end

    def chat_params
      params.permit(:number)
    end

    def next_chat_number
      number = REDIS_CLIENT.get("app_#{@application.token}_next_chat_number")

      if !number
        REDIS_CLIENT.set("app_#{@application.token}_next_chat_number" , 1)
        number = 1
      end
      REDIS_CLIENT.incr("app_#{@application.token}_next_chat_number")

      return number
    end
end
