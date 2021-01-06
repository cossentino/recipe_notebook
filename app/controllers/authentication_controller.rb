

class AuthenticationController < ApplicationController

    get '/authentication/login' do
        erb :'/authentication/login', :layout => :'../views/authentication/layout'
    end

    get '/authentication/signup' do
        erb :'/authentication/signup', :layout => :'../views/authentication/layout'
    end





end