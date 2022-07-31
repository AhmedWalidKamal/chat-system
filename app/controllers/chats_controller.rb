class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:show, :update, :destroy]

  def index
    @chats = @application.chats.all
    render json: @chats
  end

  def show
    render json: @chat
  end

  def create
    @chat = @application.chats.build(chat_params)

    if @chat.save
      render json: @chat
    else
      render json: @chat.errors, status: :bad_request
    end
  end

  def update
    if @chat.update(chat_params)
      render json: @chat
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
