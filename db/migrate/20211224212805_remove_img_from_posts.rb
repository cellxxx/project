# frozen_string_literal: true

class RemoveImgFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :img, :string
  end
end
