class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user
  before_action :info_user, only: [:create, :destroy]

  def create
    current_user.followings << @user
    render 'replace_follow'
  end

  def destroy
    current_user.followings.destroy(@user)
		render 'replace_follow'
  end

  def followings
		@users = @user.followings
  end

  def followers
		@users = @user.followers
  end

  private

  def ensure_user
    @user = User.find(params[:user_id])
  end

  def info_user
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:action] == "show"
      @info_user = @user
      @is_room, @room_id, @room, @entry = Room.ensure_room(@info_user, current_user)
    else
      @info_user = current_user
    end
  end

end
