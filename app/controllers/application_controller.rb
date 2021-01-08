require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get "/" do
    if is_logged_in?
      redirect "/recipes"
    else
      erb :'/application/welcome', layout: :'/users/layout'
    end
  end

  helpers do

    def current_user
      User.find(session[:user_id])
    end

    def is_logged_in?
      !!session[:user_id]
    end

    def view_or_redirect(view_page)
      if is_logged_in?
        erb view_page
      else
        redirect to '/authentication/login'
      end
    end

  end


end
