class StaticController < ApplicationController
  before_filter :current_user  

  def telephone
    
    # Look up user by id and call their SIP address and posted number
    userid = params[:id]
    if userid      
      if userid.index("@")
        if !userid.index("sip:")
          @phone = "sip:" + userid
        else
          @phone = userid
        end
        @did = userid
        @display = userid
      else
        @user = User.find_by_username(userid)
        if @user
          @transfermode = "one" # "all" = simultaneous rings or "one" = one phone at a time
          @did = ""
          if @user.sip
            sipraw = @user.sip
            if sipraw.index("@") and !sipraw.index("sip:")
              sipraw = "sip:" + sipraw
            end
            @did << sipraw + ","
          end
          if @user.phonenumber
            phoneraw = @user.phonenumber.gsub("-", "").gsub("(", "").gsub(")", "").gsub("+", "")
            if phoneraw.index("@") and !phoneraw.index("sip:")
              phoneraw = "sip:" + phoneraw
            end
            if isNumeric(phoneraw) and phoneraw.length == 10
              phoneraw = "1" + phoneraw
            end
            @did << phoneraw + ","
          end
          @did = @did.chop #remove last comma from @did string
          # @phone = "app:9991443419" # TROPO
          # @phone = "app:9991457150" # CCXML
          @phone = "sip:9991452579@stagingsbc-external.orl.voxeo.net"
        end
      end
    else
      # @display = "Enter number to dial"
      @display = ""
    end
    
    
    render 'telephone', :layout => false
  end
end
