class MessagesController < ApplicationController

  def create
    message = current_user.messages.new(message_params)
    @messages = Room.find(message.room_id).messages
    flash[:alert] = "メッセージ送信に失敗しました。" unless message.save
    render 'rooms/create'
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end

end
