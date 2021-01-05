class CreateRecipes < ActiveRecord::Migration
  def change

    create_table :recipes do |t|
      t.string :name
      t.string :meal
      t.string :cuisine
      t.string :cook_time
      t.string :author
      t.date :date_created
      t.integer :user_id
    end
  end
end
