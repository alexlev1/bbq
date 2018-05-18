class ApplicationMailer < ActionMailer::Base
  default from: 'info@bbqmaster.herokuapp.com'

  layout 'mailer'
end
