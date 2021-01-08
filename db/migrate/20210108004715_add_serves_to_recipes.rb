class AddServesToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :serves, :string
  end
end
