class AddCommentsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :comments, :string
  end
end
