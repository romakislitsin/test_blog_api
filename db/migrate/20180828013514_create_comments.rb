class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body, null:false
      t.integer :post_id, null:false
      t.datetime :published_at
    end
    add_column :comments, :author_id, :integer
    add_index :comments, :author_id
  end
end
