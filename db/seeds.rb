recipes_list = {
    "Sage Butter Linguini" => {
      :cuisine => "Italian",
      :meal => "dinner",
      :cook_time => "1 hour"
    },
    "Coconut Curry Soup" => {
      :cuisine => "Thai",
      :meal => "dinner",
      :cook_time => "1 hour"
    },
    "Tortilla Soup" => {
      :cuisine => "Mexican",
      :meal => "lunch",
      :cook_time => "1 hour"
    }
  }

recipes_list.each do |name, recipe_hash|
  p = Recipe.new
  p.name = name
  recipe_hash.each do |attribute, value|
      p[attribute] = value
  end
  p.save
end




