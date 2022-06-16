class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @users = @group.group_user.users
    @book = Book.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
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
