class Notifier < ActionMailer::Base
  # default :from => "admin@twelephone.com"
  
  def contact(toemail, fromemail, message)
    
    mail( :to => toemail,
          :from => fromemail,
          :subject => "Twlephone Update",
          :body => message)
             
  end
  
end
