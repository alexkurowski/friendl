class Mailer < ActionMailer::Base
  default from: "email@postmark.com"


  def send_reply reply_hash, email
    reply_email = Email.where(key: reply_hash).take
    unless reply_email.nil?
      reply_user = reply_email.from

      reply_to reply_user, email
    end
  end

  def send_email user
    # Find a message that is not a reply
    # that user haven't already received
    reply_email = Email.first

    # and send it to him (now or in a hour)
    reply user, reply_email
  end


  private

  def reply user, email
    puts "Email sent!"
    # mail(to: )
    email.was_sent
  end

  def reply_to user, email
    reply user, email
  end
end
