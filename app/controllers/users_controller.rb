class UsersController < ApplicationController
  before_action :ensure_user, only: [:show, :edit, :update]
  before_action :check_user, only: [:edit, :update]

  def index
    @users = User.all
    @new_book = Book.new
  end

  def show
    @books = @user.books
    @new_book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_user
    @user = User.find(params[:id])
  end

  def check_user
    redirect_to user_path(current_user) unless @user == current_user
  end

end
