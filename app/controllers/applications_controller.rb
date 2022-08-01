class ApplicationsController < ApplicationController

  include Filter

  before_action :set_application, only: %i[ show update destroy ]

  def index
    @applications = Application.all
    render filter @applications
  end

  def show
    render filter @application
  end

  def create
    @application = Application.new(application_params)
    @application.chats_count = 0

    if @application.save
      render filter @application
    else
      render json: @application.errors, status: :bad_request
    end
  end

  def update
    if @application.update(application_params)
      render filter @application
    else
      render json: @application.errors, status: :bad_request
    end
  end

  def destroy
    @application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(token: params[:token])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.permit(:name)
    end
end
