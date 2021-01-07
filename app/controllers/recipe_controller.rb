

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
        view_or_redirect(:'/recipes/show')
    end

    get '/recipes/:id/edit' do
        @recipe = Recipe.find(params[:id])
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
                new_ingredient = Ingredient.find_or_create_by(name: params[:ings][index])
                new_ingredient.quantity = params[:amts][index] if !params[:amts][index].empty?
                new_ingredient.unit = params[:units][index] if !params[:units][index].empty?
                new_recipe.ingredients << new_ingredient
                new_ingredient.save
            end
        end

        params[:meals].each do |meal|
            new_meal = Meal.find_or_create_by(name: meal)
            new_recipe.meals << new_meal
            new_meal.recipe << new_recipe
        end

        params[:steps].each do |step|
            if !step.empty?
                new_step = Instruction.new(content: step) 
                new_recipe.instructions << new_step
            end
        end
        new_recipe.save
        current_user.save
        redirect '/recipes'
    end



    helpers do

    end


end