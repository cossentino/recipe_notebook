

class AuthenticationController < ApplicationController

    get '/authentication/login' do
        erb :'/users/authentication/login', :layout => :'../views/users/layout'
    end

    get '/authentication/failure' do
        erb :'/users/authentication/failure', :layout => :'../views/users/layout'
    end

    get '/registration/signup' do
        erb :'/users/registration/signup', :layout => :'../views/authentication/layout'
    end

    post '/authentication' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect '/recipes'
        else
          redirect '/authentication/failure'
        end
    end


    post '/registration' do
        @user = User.find_by(username: params[:username])
        if !@user
            new_user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = new_user.id
            redirect '/recipes'
        end
        redirect '/registration/failure'
    end





end