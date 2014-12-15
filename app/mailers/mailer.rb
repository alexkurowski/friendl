class Mailer < ActionMailer::Base
  default from: "email@postmark.com"

  def reply user, email
    puts "Email sent!"
    # mail(to: )
    email.was_sent
  end

  def reply_to user, email
    reply user, email
  end
end
