

class AuthenticationController < ApplicationController

    get '/authentication/login' do
        erb :'/users/authentication/login', :layout => :'../views/users/layout'
    end

    get '/authentication/failure' do
        erb :'/users/authentication/failure', :layout => :'../views/users/layout'
    end

    get '/registration/signup' do
        erb :'/users/registration/signup', :layout => :'../views/users/layout'
    end

    get '/registration/failure' do
        erb :'/users/registration/failure', :layout => :'../views/users/layout'
    end

    get '/authentication/logout' do
        logout
        redirect '/authentication/login'
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
        @new_user = User.find_by(username: params[:username])
        if !@new_user
            @new_user = User.create(username: params[:username], password: params[:password])
            login(@user)
        end
        redirect '/registration/failure'
    end



    helpers do
        def login(user)
            session[:user_id] = user.id
            redirect '/recipes'
        end

        def logout
            session.clear
            redirect '/authentication/login'
        end


    end
end