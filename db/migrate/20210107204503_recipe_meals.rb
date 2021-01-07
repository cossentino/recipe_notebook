class RecipeMeals < ActiveRecord::Migration
  def change
    create_table :recipe_meals do |t|
      t.integer :recipe_id
      t.integer :meal_id
    end
  end
end
