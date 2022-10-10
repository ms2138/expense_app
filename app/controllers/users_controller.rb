class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  after_action :verify_authorized, except: :index

  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = authorize User.find(params[:id])
    redirect_to root_url if @user.nil?
  end
end
