$('#notebar').append('<div id="comment_<%=@comment.id%>"><span class="charge"><%=@comment.verse.chapter.to_s + ":" + @comment.verse.number.to_s%></span> <span class="on_the_spot_in_tree_editing" data-auth="SI9+nkHhHtgpbpQcWLYkuXTUxD/UyduveFSvH7g9ruc=" data-cancel="Cancel" data-ok="Ok" data-tooltip="Click to edit note" data-url="/comments/update_attribute_on_the_spot_in_tree" id="comment__comment__<%=@comment.id.to_s%>" style="background-color: inherit;"><%=@comment.comment%></span> <a href="/comments/<%=@comment.id%>" data-confirm="Are you sure you want to delete this note?" data-method="delete" data-remote="true" rel="nofollow"><img alt="X" src="/assets/x.png" title="delete note" width="15" /></a></div>') 
  .hide()
  .fadeIn()
$('#commentsdisp_<%= @comment.verse.id%>').hide()


