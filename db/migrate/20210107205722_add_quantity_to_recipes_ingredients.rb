class AddQuantityToRecipesIngredients < ActiveRecord::Migration
  def change
    add_column :recipes_ingredients, :quantity, :string
  end
end
