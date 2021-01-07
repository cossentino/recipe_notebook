class RemoveQuantityAndUnitFromIngredients < ActiveRecord::Migration
  def change
    remove_column :ingredients, :unit
    remove_column :ingredients, :quantity
  end
end
