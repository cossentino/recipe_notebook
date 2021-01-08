

class RecipeController < ApplicationController

    get '/recipes' do
        puts session
        @recipes = current_user.recipes
        view_or_redirect(:'/recipes/index')
    end

    get '/recipes/new' do
        @meals = ['Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snack']
        view_or_redirect(:'/recipes/new')
    end

    get '/recipes/:id' do
        @recipe = Recipe.find(params[:id])
        @ingredients = @recipe.ingredients
        view_or_redirect(:'/recipes/show')
    end

    get '/recipes/:id/edit' do
        @meals = ['Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snack']
        @recipe = Recipe.find(params[:id])
        @ingredients = @recipe.ingredients
        puts @ingredients.pluck("name")
        view_or_redirect(:'/recipes/edit')
    end

    post '/recipes' do
        puts params
        new_recipe = Recipe.new(params[:recipe])
        current_user.recipes << new_recipe
        ingredients_array = params[:ings]
      
        params[:ings].each do |ing|
            if !ing.empty?
                index = params[:ings].index(ing)
                new_recipe.ingredients <<  Ingredient.find_or_create_by(name: params[:ings][index])
                recipe_ingredient = RecipeIngredient.last
                recipe_ingredient.quantity = params[:quants][index] if !params[:quants][index].empty?
                recipe_ingredient.save
            end
        end

        if !!params[:meals]
            params[:meals].each do |meal|
                new_meal = Meal.find_or_create_by(name: meal)
                new_recipe.meals << new_meal
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

    patch '/recipes/:id' do
        puts params
        recipe = Recipe.find(params[:id])
        recipe.ingredients.clear; recipe.instructions.clear; recipe.meals.clear
        ingredients_array = params[:ings]
        
      
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


end