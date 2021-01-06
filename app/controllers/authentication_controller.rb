

class AuthenticationController < ApplicationController

    get '/authentication/login' do
        erb :'/authentication/login'
    end

    get '/authentication/signup' do
        erb :'/authentication/signup'
    end



end