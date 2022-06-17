class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user, only: [:show, :edit, :update]
  before_action :check_user, only: [:edit, :update]

  def index
    @users = User.all
    @book = Book.new
  end

  def show
    @books = @user.books
    @book_count = [@books.where(created_at: Time.zone.now.all_day).count]
    @days = ["今日"]
    for num in 1..6 do
      @book_count.push(@books.where(created_at: num.day.ago.all_day).count)
      @days.push("#{num}日前")
    end
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    @book = Book.new
    if @user != current_user
      Entry.where(user_id: current_user.id).each do |cu|
        Entry.where(user_id: @user.id).each do |u|
          if cu.room_id == u.room_id
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
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