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


end
