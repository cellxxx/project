# frozen_string_literal: true

class CreateIndices < ActiveRecord::Migration[6.1]
  def change
    create_table :indices do |t|
      t.string :array
      t.string :result
      t.boolean :error
      t.string :longest_one

      t.timestamps
    end
  end
end
