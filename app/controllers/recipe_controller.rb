

class RecipeController < ApplicationController

    MEALS = ['Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snack']

    get '/recipes' do
        puts session
        @recipes = current_user.recipes
        view_or_redirect(:'/recipes/index')
    end

    get '/recipes/test' do
        erb :'/recipes/test'
    end

    post '/tests' do
        puts params
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
        @ingredients = @recipe.ingredients
        if is_correct_user_for_recipe?(session[:user_id], @recipe.user_id)
            view_or_redirect(:'/recipes/edit')
        else
            redirect to '/recipes'
        end
    end

    post '/recipes' do
        ## Data Validation - ensure mandatory fields not empty
        @empty_field_names = []
        params[:recipe].keys.each do |key|
            if params[:recipe][key].empty?
                @empty_field_names << key
            end
        end
    
        ## If any fields are empty, redirect to form with instructions to complete
        if !@empty_field_names.empty?
            puts params
            @recipe_data = params
            erb :'/recipes/retry'

        ## Proceed with storing recipe        
        else
            new_recipe = create_new_recipe(params[:recipe])
            recipe_builder(new_recipe, params[:ingreds], params[:meals], params[:steps])
            current_user.save
            redirect "/recipes/#{new_recipe.id}"
        end
    end

    patch '/recipes/:id' do
        recipe = Recipe.find(params[:id])
        recipe.update(params[:recipe])
        recipe.ingredients.clear; recipe.instructions.clear; recipe.meals.clear
        recipe_builder(recipe, params[:ingreds], params[:meals], params[:steps])
        current_user.save
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
                if !ingred.values.all? {|v| v = ""}
                    recipe.ingredients << Ingredient.find_or_create_by(name: ingred["name"]) if !ingred["name"].empty?
                    RecipeIngredient.last.quantity = ingred["quantity"] if !ingred["quantity"].empty?
                    RecipeIngredient.last.save
                end
            end
        end

        def add_new_meal(recipe, meals_array)
            if !!array
                array.each do |meal_name|
                    recipe.meals << Meal.find_or_create_by(name: meal_name)
                end
            end
        end

        def add_new_step(recipe, steps_array)
            if !!array
                array.each do |step|
                    recipe.instructions << Instruction.find_or_create_by(content: step)
                end
            end
        end

        def recipe_builder(recipe, ingredients, meals, steps)
            add_ingredients(recipe, ingredients)
            add_new_meal(recipe, meals)
            add_new_step(recipe, steps)
        end

        def generate_invalid_fields_array(recipe_hash)
            @empty_field_name = recipe_hash.values.map do { |v| v.empty ? v : next }
                


    



    end
end