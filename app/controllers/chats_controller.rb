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
    @chat = @application.chats.build(chat_params)
    @chat.messages_count = 0

    if @chat.save
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
end
