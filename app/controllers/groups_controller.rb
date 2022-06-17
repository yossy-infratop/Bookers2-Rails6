class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group, only: [:show, :join, :edit, :update, :destroy, :new_mail, :send_mail]
  before_action :ensure_correct_user, only: [:edit, :update, :new_mail, :send_mail]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.includes(:users)
    @book = Book.new
  end

  def show
    @owner = User.find(@group.owner_id)
    @book = Book.new
  end

  def join
    @group.users << current_user
    redirect_to groups_path
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def new_mail
  end

  def send_mail
    @title = params[:title]
    @content = params[:content]
    ContactMailer.send_mail(@title, @content, @group.users, current_user).delivery_method
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_group
    @group = Group.find(params[:id])
  end

  def ensure_correct_user
    redirect_to groups_path unless @group.owner_id == current_user.id
  end

end
