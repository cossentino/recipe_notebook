

class RecipeController < ApplicationController

    get '/recipes' do
        erb :'/recipes/index'
    end


end