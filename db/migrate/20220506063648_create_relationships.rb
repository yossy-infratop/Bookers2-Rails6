class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false #フォローするユーザのid
      t.integer :followed_id, null: false #フォローされるユーザのid

      t.timestamps
    end
  end
end
