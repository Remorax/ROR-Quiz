class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :answerString, :text
    add_column :users, :score, :integer
  end
end
