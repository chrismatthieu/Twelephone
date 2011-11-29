require 'rubygems'
require 'json'
require 'rest-client'

@username = $currentCall.getHeader("x-username")
@myusername = $currentCall.getHeader("x-myusername")

log "user=" + @username
log "myuser=" + @myusername

@getorg = RestClient.get 'http://twelephone.com/api/address/' + @username + '.json'
@getorgdata = JSON.parse(@getorg)
if @getorgdata["sip"]
   log "jabber=" + @getorgdata["sip"]
end   

message @myusername + ' joined twelephone call', {
       :to => @getorgdata["sip"],
       :network => "JABBER"}     


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
   },
   :onHangup => lambda { |event|
           message @myusername + ' left twelephone call', {
                  :to => @getorgdata["sip"],
                  :network => "JABBER"}     
           
    }}
say "We hope you had fun, call back soon!"