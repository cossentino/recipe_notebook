

class AuthenticationController < ApplicationController

    get '/authentication/login' do
        erb :'/authentication/login', :layout => :'../views/authentication/layout'
    end

    get '/registration/signup' do
        erb :'/authentication/signup', :layout => :'../views/authentication/layout'
    end

    post '/authentication' do
        @user = User.find_by(username: params[:username], password: params[:password])
        if @user
          session[:user_id] = @user.id
          redirect '/recipes'
        end
        redirect '/sessions/login'
    end

    post '/registration' do
        @user = User.find_by(username: params[:username])
        if !@user
            new_user = User.new(username: params[:username], password: params[:password])
            session[:user_id] = @user.id
            redirect '/recipes'
        end
        redirect '/sessions/login'
    end





end