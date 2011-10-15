class Notifier < ActionMailer::Base
  # default :from => "admin@maywehelp.com"
  
  def contact(toemail, fromemail, message)
    
    mail( :to => toemail,
          :from => fromemail,
          :subject => "MayWeHelp Update",
          :body => message)
             
  end
  
end
