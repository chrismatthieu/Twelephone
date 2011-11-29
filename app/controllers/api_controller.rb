class ApiController < ApplicationController

  # GET :: Lookup last known SIP address of user /api/address/chris.json
  def address

    @address = User.where("username = ?", params[:user]).first
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { 
        if @address
          render           
        else
          render :json => '{"error" : "NotFound", "message" : "User not found."}', :status => :not_found 
        end
        }
    end
  end

  def update_phonoaddress
    # Receives AJAX call to report telephone SIP address
    @user = User.find(session[:user_id])
    @user.sip = params[:mysession]      
    @user.save
    session[:sip] = params[:mysession]   
    
    respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
    end
  end


end
