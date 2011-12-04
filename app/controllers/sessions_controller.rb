class SessionsController < ApplicationController
  def new
  end
  # def create
  #   user = User.find_by_username(params[:username])
  #   if user && user.authenticate(params[:password])
  #     session[:user_id] = user.id
  #     redirect_to root_url, :notice => "Logged in"
  #   else
  #     flash.now.alert = "Invalid email or password"
  #     render "new"
  #   end
  # end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out"
  end
  
  
  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']
    
    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every service
      
      # create a new hash
      @authhash = Hash.new
      
      if service_route == 'facebook'
        omniauth['extra']['user_hash']['email'] ? @authhash[:email] =  omniauth['extra']['user_hash']['email'] : @authhash[:email] = ''
        omniauth['extra']['user_hash']['username'] ? @authhash[:name] =  omniauth['extra']['user_hash']['username'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ?  @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''

        omniauth['user_info']['image'] ? @authhash[:photo] =  omniauth['user_info']['image'] : @authhash[:photo] = ''
        
        @authhash[:token] = ""
        @authhash[:secret] = ""
        
      elsif service_route == 'twitter'
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['nickname'] ? @authhash[:nickname] =  omniauth['user_info']['nickname'] : @authhash[:nickname] = ''
        # omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''        

        omniauth['user_info']['image'] ? @authhash[:photo] = omniauth['user_info']['image'] : @authhash[:photo] = ''        
        
        omniauth['credentials']['token'] ? @authhash[:token] = omniauth['credentials']['token'] : @authhash[:token] = ''        
        omniauth['credentials']['secret'] ? @authhash[:secret] = omniauth['credentials']['secret'] : @authhash[:secret] = ''        
        omniauth['extra']['user_hash']['profile_background_image_url'] ? @authhash[:backgroundimage] =  omniauth['extra']['user_hash']['profile_background_image_url'] : @authhash[:backgroundimage] = ''
        omniauth['extra']['user_hash']['profile_background_color'] ? @authhash[:backgroundcolor] =  omniauth['extra']['user_hash']['profile_background_color'] : @authhash[:backgroundcolor] = ''
        omniauth['extra']['user_hash']['profile_background_tile'] ? @authhash[:backgroundtile] =  omniauth['extra']['user_hash']['profile_background_tile'] : @authhash[:backgroundtile] = ''
        omniauth['extra']['user_hash']['description'] ? @authhash[:bio] =  omniauth['extra']['user_hash']['description'] : @authhash[:bio] = ''
        omniauth['extra']['user_hash']['location'] ? @authhash[:location] =  omniauth['extra']['user_hash']['location'] : @authhash[:location] = ''
        omniauth['extra']['user_hash']['url'] ? @authhash[:url] =  omniauth['extra']['user_hash']['url'] : @authhash[:url] = ''
                        
      else        
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end 
      
      if @authhash[:uid] != '' and @authhash[:provider] != ''
        
        auth = User.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        if auth 
          session[:user_id] = auth.id
          session['access_token'] = auth.access_token
          session['access_secret'] = auth.access_secret
          
          # redirect_to "/feed", :notice => "Logged in"
          # redirect_to "/" + auth.username #, :notice => "Logged in"
          if session[:target]
            redirect_to "/" + session[:target] #, :notice => "User was successfully created."
          else
            redirect_to "/" + auth.username #, :notice => "User was successfully created."
          end
          
          
        else

          # puts omniauth['uid']
          # puts omniauth['user_info']['nickname']
          # puts omniauth['user_info']['name']
          # puts omniauth['user_info']['email']
          # puts omniauth['user_info']['image']
          # puts omniauth['user_info']['description']
          # puts omniauth['credentials']['token']
          # puts omniauth['credentials']['secret']

          @user = User.new
          @user.username = @authhash[:nickname]
          @user.email = @authhash[:email]
          @user.provider = @authhash[:provider]
          @user.uid = @authhash[:uid]
          @user.photo = @authhash[:photo]  
          @user.password = rand(10000000)        
          @user.allowemail = true
          @user.access_token = @authhash[:token]  
          @user.access_secret = @authhash[:secret]  
          @user.backgroundurl = @authhash[:backgroundimage]  
          @user.backgroundcolor = @authhash[:backgroundcolor]  
          @user.backgroundtile = @authhash[:backgroundtile]  
          @user.bio = @authhash[:bio]  
          @user.bio = @authhash[:location]  
          @user.bio = @authhash[:url]  

          @user.save
          
          if !@user.email.nil?
            # Send welcome email
            @message = "Welcome to Twlephone!"
            # Notifier.contact(@authhash[:email], "chris@twelephone.com", @message).deliver
          end 
          
          session[:user_id] = @user.id      
          session['access_token'] = @user.access_token
          session['access_secret'] = @user.access_secret
          # redirect_to "/feed", :notice => "User was successfully created."
          
          if session[:target]
            redirect_to "/" + session[:target] #, :notice => "User was successfully created."
          else
            redirect_to "/" + @user.username #, :notice => "User was successfully created."
          end
          
        end
        
      else
        flash[:notice] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to root_url
      end
    else
        user = User.find_by_username(params[:username])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect_to "/" + user.username #, :notice => "Logged in"
        else
          flash.now.alert = "Invalid email or password"
          render "new"
        end

    end
  end
  
  # callback: failure
  def failure
    flash[:notice] = 'There was an error at the remote authentication service. You have not been signed in.'
    redirect_to root_url
  end  
  
end
