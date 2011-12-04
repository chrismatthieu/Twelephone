require 'rubygems'
require 'json'
require 'rest-client'

@username = $currentCall.getHeader("x-username")
@myusername = $currentCall.getHeader("x-myusername")
@myphoto = $currentCall.getHeader("x-myphoto")
@myjid = $currentCall.getHeader("x-myjid")

log "user=" + @username
log "myuser=" + @myusername
log "myphoto=" + @myphoto
log "myjid=" + @myjid

apiurl = "http://web1.tunnlr.com:11053"
# apiurl = "http://twelephone.com"

@getorg = RestClient.get apiurl + '/api/address/' + @username + '.json'
@getorgdata = JSON.parse(@getorg)
if @getorgdata["sip"]
   log "jabber=" + @getorgdata["sip"]
end   

message @myusername + '~' + @myphoto + '~' + @myjid + "~joined", {
       :to => @getorgdata["sip"],
       :network => "JABBER"}     


if @username.nil?
  @username = "anonymous_user"
end
@confid = "twele" + @username

say "connected to twelephone conference for " +  @username
say "now tweet this link for others to join you. twelephone dot com slash " + @username

conference @confid , {
  :playTones => true
  }
  
if !$currentCall.isActive
     message @myusername + '~' + @myphoto + '~' + @myjid + "~left", {
            :to => @getorgdata["sip"],
            :network => "JABBER"}     
end       
