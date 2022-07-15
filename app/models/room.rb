class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  def self.ensure_room(user, current_user)
    # 8a : DM機能
    if user != current_user
      Entry.where(user_id: current_user.id).each do |cu|
        Entry.where(user_id: user.id).each do |u|
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
    return @is_room, @room_id, @room, @entry
  end

end