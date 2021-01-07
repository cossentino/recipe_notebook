

class RecipeMeal < ActiveRecord::Base
    belongs_to :recipe
    belongs_to :meal
end