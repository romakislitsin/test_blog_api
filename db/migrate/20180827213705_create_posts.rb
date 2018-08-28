class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null:false
      t.string :body, null:false
      t.datetime :published_at
    end
    add_column :posts, :author_id, :integer
    add_index :posts, :author_id
  end
end
