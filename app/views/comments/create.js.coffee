$('#notebar').append('<div id="comment_<%=@comment.id%>"><span class="charge"><%=@comment.verse.chapter.to_s + ":" + @comment.verse.number.to_s%></span> <%= @comment.comment rescue ""%> <a href="/comments/<%=@comment.id%>" data-confirm="Are you sure?" data-method="delete" data-remote="true" rel="nofollow"><img alt="X" src="/assets/x.png" title="delete comment" width="15" /></a></div>') 
  .hide()
  .fadeIn()
$('#commentsdisp_<%= @comment.verse.id%>').hide()