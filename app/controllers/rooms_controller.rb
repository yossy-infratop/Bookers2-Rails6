class RoomsController < ApplicationController

  def create
    room = Room.create
    Entry.create(room_id: room.id, user_id: current_user.id)
    Entry.create(room_id: room.id, user_id: params[:room][:user_id])
    redirect_to room_path(room.id)
  end

  def show
    @room = Room.find(params[:id])
    if @room.entries.where(user_id: current_user.id, room_id: @room.id).exists?
      @messages = @room.messages.includes(:user)
      @message = Message.new
      @another_user = @room.entries.where.not(user_id: current_user.id)[0].user
    else
      redirect_to users_path
    end
  end

end