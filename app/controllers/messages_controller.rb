class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [:show, :update, :destroy]

  def index
    @messages = @chat.messages.all
    render json: @messages
  end

  def show
    render json: @message
  end

  def create
    @message = @chat.messages.build(message_params)

    if @message.save
      render json: @message
    else
      render json: @message.errors, status: :bad_request
    end
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :bad_request
    end
  end

  def destroy
    @message.destroy
  end

  private

    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end

    def set_chat
      @chat = @application.chats.find_by!(number: params[:chat_number])
    end

    def set_message
      @message = @chat.messages.find_by!(number: params[:number])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.permit(:body, :number)
    end
end
