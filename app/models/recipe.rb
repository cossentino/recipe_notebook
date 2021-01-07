

class Recipe < ActiveRecord::Base
    has_many :recipes_ingredients
    has_many :ingredients, through: :recipes_ingredients
    has_many :recipe_meals
    has_many :meals, through: :recipe_meals
    has_many :instructions
    belongs_to :user
end