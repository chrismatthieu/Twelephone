<% if params[:status] == "unfollow"%>

$('#userstatus').html('<form accept-charset="UTF-8" action="/follows?id=<%=params[:id]%>&amp;status=follow" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="q5PZvleStCQT/W3Et0axfGEUndnHyLFdeouxLN1AKLE=" /></div><button name="button" title="Follow <%=@user.username.capitalize%>" type="submit">Follow</button></form>')

<% else %>

$('#userstatus').html('<form accept-charset="UTF-8" action="/follows?id=<%=params[:id]%>&amp;status=unfollow" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="q5PZvleStCQT/W3Et0axfGEUndnHyLFdeouxLN1AKLE=" /></div><button name="button" title="Unfollow <%=@user.username.capitalize%>" type="submit">Unfollow</button></form>')

<% end %>
