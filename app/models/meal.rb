

class Meal < ActiveRecord::Base
    has_many :recipe_meals
    has_many :recipes, through: :recipe_meals
end