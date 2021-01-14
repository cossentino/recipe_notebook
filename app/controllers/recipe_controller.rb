

class RecipeController < ApplicationController

    MEALS = ['Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snack']

    get '/recipes' do
        puts session
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
    
        ## Show variant of edit form using params from post request
        if !@empty_field_names.empty?
            puts params
            @recipe_data = params
            erb :'/recipes/retry'

        ## If valid, proceed with storing recipe        
        else
            new_recipe = create_new_recipe(params[:recipe])
            params[:ings].each do |ing|
                if !ing.empty?
                    index = params[:ings].index(ing)
                    new_recipe.ingredients <<  Ingredient.find_or_create_by(name: params[:ings][index])
                    RecipeIngredient.last.quantity = params[:quants][index] if !params[:quants][index].empty?
                    RecipeIngredient.last.save
                end
            end
        
            if !!params[:meals]
                params[:meals].each do |meal|
                    new_recipe.meals <<  Meal.find_or_create_by(name: meal)
                end
            end

            params[:steps].each do |step|
                if !step.empty?
                    new_step = Instruction.new(content: step) 
                    new_recipe.instructions << new_step
                end
            end
            new_recipe.save
            current_user.save
            redirect "/recipes/#{new_recipe.id}"
        end
    end

    patch '/recipes/:id' do
        recipe = Recipe.find(params[:id])
        recipe.ingredients.clear; recipe.instructions.clear; recipe.meals.clear
        
        params[:ings].each do |ing|
            if !ing.empty?
                index = params[:ings].index(ing)
                recipe.ingredients << Ingredient.find_or_create_by(name: ing)
                recipe_ingredient = RecipeIngredient.last
                recipe_ingredient.quantity = params[:quants][index] if !params[:quants][index].empty?
                recipe_ingredient.save
            end
        end

        if !! params[:meals]
            params[:meals].each do |meal|
                new_meal = Meal.find_or_create_by(name: meal)
                recipe.meals << new_meal
            end
        end

        params[:steps].each do |step|
            if !step.empty?
                new_step = Instruction.new(content: step) 
                recipe.instructions << new_step
            end
        end
        recipe.update(params[:recipe])
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
                if !ing.empty?
                    recipe.ingredients << Ingredient.find_or_create_by(name: ingred)

            

    end
end