class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.text :question
      t.string :a
      t.string :b
      t.string :c
      t.string :d
      t.integer :genreID
      t.integer :subgenreID
      t.string :answer
      t.integer :questionType
      t.text :userAnswers

      t.timestamps
    end
  end
end
