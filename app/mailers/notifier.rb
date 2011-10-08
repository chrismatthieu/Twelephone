class Notifier < ActionMailer::Base
  # default :from => "admin@gospelr.com"
  
  def contact(toemail, fromemail, message)
    
    mail( :to => toemail,
          :from => fromemail,
          :subject => "Gospelr Update",
          :body => message)
             
  end
  
end
