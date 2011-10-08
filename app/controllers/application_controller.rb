class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def omniauth
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def admin_required
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

    if @current_user 
      if !@current_user.admin
        redirect_to '/'
      end
    else
       redirect_to '/'
    end
  end
  
  def user_signed_in?
    return 1 if current_user 
  end
  

  def login_required
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

    if !@current_user 
       redirect_to '/'
    end
  end

  def isNumeric(s)
      Float(s) != nil rescue false
  end
  
  def client
    Twitter.configure do |config|
      config.consumer_key = 'MirwMXxnomdhnywG6ynag' #ENV['CONSUMER_KEY']
      config.consumer_secret = 'keUu5ggHjmGL40YsRZjgIeIGjeswjA9E4KZJLfP9k' #ENV['CONSUMER_SECRET']
      # Gospelr's tokens for verse tweets
      config.oauth_token = '68235743-Wd3u8i0BQg6YASSYsU98y8KnZSfZQT6S2s2zVqQAg' #session['access_token']
      config.oauth_token_secret = 'X23N6CAgJ9SExZTmPBKSrR7oxpapCuoVVxKvEyPyA' #session['access_secret']
    end
    @client ||= Twitter::Client.new
  end  

end
