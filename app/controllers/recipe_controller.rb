

class RecipeController < ApplicationController

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
        view_or_redirect(:'/recipes/show')
    end

    post '/recipes' do
        new_recipe = Recipe.new(params[:recipe])
        current_user.recipes << new_recipe
        ingredients_array = params[:ings]
      
        params[:ings].each do |ing|
            if !ing.empty?
                index = params[:ings].index(ing)
                new_ingredient = Ingredient.new(name: params[:ings][index], quantity: params[:amts][index], unit: params[:units][index])
                new_recipe.ingredients << new_ingredient
                new_ingredient.save
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
        redirect '/recipes'
    end



    helpers do
        def current_user
            User.find(session[:user_id])
        end
    end


end