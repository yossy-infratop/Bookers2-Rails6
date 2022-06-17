class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user

  def create
    current_user.followings << @user
		redirect_to request.referer
  end

  def destroy
    current_user.followings.destroy(@user)
		redirect_to request.referer
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

end
