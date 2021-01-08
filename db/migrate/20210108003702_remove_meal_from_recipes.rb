class RemoveMealFromRecipes < ActiveRecord::Migration
  def change
    remove_column :recipes, :meal
  end
end
