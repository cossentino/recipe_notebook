

class RecipeController < ApplicationController

    MEALS = ['Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snack']

    ########## GET #################################################################
    
    get '/recipes' do
        @recipes = current_user.recipes
        view_or_redirect(:'/recipes/index')
    end
    
    get '/recipes/new' do
        view_or_redirect(:'/recipes/new')
    end

    get '/recipes/:id' do
        @recipe = Recipe.find(params[:id])
        @ingredients = @recipe.ingredients
        if is_correct_user_for_recipe?(session[:user_id], @recipe.user_id)
            view_or_redirect(:'/recipes/show')
        else
            redirect to '/recipes'
        end
    end

    get '/recipes/:id/edit' do
        @recipe = Recipe.find(params[:id])
        @recipe_ingredients = RecipeIngredient.where(recipe_id: @recipe.id )
        if is_correct_user_for_recipe?(session[:user_id], @recipe.user_id)
            view_or_redirect(:'/recipes/edit')
        else
            redirect to '/recipes'
        end
    end

    ########## POST ##################################################################

    post '/recipes' do
        ## Data Validation - ensure mandatory fields not empty
        @invalid_fields = generate_invalid_fields_array(params[:recipe])

        ## If any fields are empty, redirect to form with instructions to complete
        if !@invalid_fields.all? {|f| f == nil }
            @recipe_data = params
            erb :'/recipes/retry'

        ## Proceed with storing recipe        
        else
            new_recipe = create_new_recipe(params[:recipe])
            recipe_builder(new_recipe, params[:ingreds], params[:meals], params[:steps])
            new_recipe.save
            redirect "/recipes/#{new_recipe.id}"
        end
    end

    ########## PATCH/DELETE #########################################################

    patch '/recipes/:id' do
        recipe = Recipe.find(params[:id])
        recipe.update(params[:recipe])
        recipe.ingredients.clear; recipe.instructions.clear; recipe.meals.clear
        recipe_builder(recipe, params[:ingreds], params[:meals], params[:steps])
        recipe.save
        redirect "/recipes/#{recipe.id}"
    end

    delete '/recipes/:id' do
        @recipe = Recipe.find(params[:id])
        @recipe.destroy
        redirect '/recipes'
    end


    helpers do

        def params_to_labels(array)
            array.map do |elem|
                case elem
                when "name"
                    elem = "Recipe Name"
                when "author"
                    elem = "Chef"
                when "cuisine"
                    elem = "Cuisine"
                when "serves"
                    elem = "Serves"
                when "cook_time"
                    elem = "Cooking/Prep Time"
                else
                    elem
                end
            end
        end
        
        def is_correct_user_for_recipe?(user_id, recipe_user_id)
            user_id == recipe_user_id
        end

        def create_new_recipe(recipe_hash)
            new_recipe = Recipe.new(recipe_hash)
            current_user.recipes << new_recipe
            new_recipe
        end

        def add_ingredients(recipe, ingreds_array)
            ingreds_array.each do |ingred|
                if !ingred.values.all? {|v| v == ""}
                    recipe.ingredients << Ingredient.find_or_create_by(name: ingred["name"]) if !ingred["name"].empty?
                    RecipeIngredient.last.update(quantity: ingred["quant"]) if !ingred["quant"].empty?
                end
            end 
        end

        def add_meals(recipe, meals_array)
            if !!meals_array
                meals_array.each do |meal_name|
                    recipe.meals << Meal.find_or_create_by(name: meal_name)
                end
            end
        end

        def add_steps(recipe, steps_array)
            if !!steps_array
                steps_array.each do |step|
                    if !step.empty?
                    recipe.instructions << Instruction.find_or_create_by(content: step)
                    end
                end
            end
        end

        def recipe_builder(recipe, ingredients, meals, steps)
            add_ingredients(recipe, ingredients)
            add_meals(recipe, meals)
            add_steps(recipe, steps)
        end

        def generate_invalid_fields_array(recipe_hash)
            invalid_fields = recipe_hash.keys.map do |key|
                if recipe_hash[key].empty?
                    key
                end
            end
        end

        def sentence_case(string)
            caps_array = string.split(" ").map { |s| s.capitalize }
            caps_array.join(" ")
        end
    end
end