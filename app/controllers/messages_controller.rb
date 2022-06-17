class MessagesController < ApplicationController

  def create
    message = current_user.messages.new(message_params)
    flash[:alert] = "メッセージ送信に失敗しました。" unless message.save
    redirect_to room_path(message.room_id)
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end

end
