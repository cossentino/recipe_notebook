class RenameRecipesIngredientToRecipeIngredient < ActiveRecord::Migration

    def self.up
      rename_table :recipes_ingredients, :recipe_ingredients
    end
  
    def self.down
      rename_table :recipe_ingredients, :recipes_ingredients
    end
  
end
