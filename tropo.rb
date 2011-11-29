require 'rubygems'
require 'json'
require 'rest-client'

@username = $currentCall.getHeader("x-username")
@myusername = $currentCall.getHeader("x-myusername")

log "user=" + @username
log "myuser=" + @myusername

if @username == @myusername
  @getorg = RestClient.get'http://twelephone.com/api/address/' + @username + '.json'
  @getorgdata = JSON.parse(@getorg)
  if @getorgdata["sip"]
     log "sip=" + @getorgdata["sip"]
  end
end

if @username.nil?
  @username = "anonymous_user"
end
@confid = "twele" + @username

say "connected to twelephone conference for " +  @username
say "now tweet this link for others to join you. twelephone dot com slash " + @username

conference @confid , {
  :terminator => "#",
  :playTones => true,
  :onChoice => lambda { |event| 
        say("Disconnecting")    
   }}
say "We hope you had fun, call back soon!"
