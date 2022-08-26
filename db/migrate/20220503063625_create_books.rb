class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.string :user_id, null: false
      t.float :rate, default: 0, null: false
      t.string :image_url, null: false
      t.string :item_url, null: false

      t.timestamps
    end
  end
end