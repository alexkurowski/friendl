class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # Receive an email and decide what to do with it
  def receive
    user = User.fetch_address params['sender'] # from field of the mail with the address (my@example.com)

    subject = params['subject'] # subject of the mail (should be added as "# subject" [md] to the mail later)
    body    = params['body']    # main text of the message

    # no_reply should check the to field of the email here
    is_reply = (body.lstrip[0].in? ['@', '#'])

    # check if mail is bad

    email = Email.create from: user,
                         subject: subject,
                         body: body,
                         no_reply: false,
                         is_reply: is_reply

    if is_reply
      send_reply get_reply_hash(body), email
    else
      send_email user
    end


    render nothing: true
  end


  private

  def get_reply_hash str
    str.lstrip[1...Email::HASH_LENGTH+1]
  end

  def send_reply reply_hash, mail
    reply_email = Email.where(key: reply_hash).take
    unless reply_email.nil?
      reply_user = reply_email.from

      Mailer.reply_to reply_user, email
    end
  end


  def send_email user
    # Find a message that is not a reply
    # that user haven't already received
    email = Email.first

    # and send it to him (now or in a hour)
    Mailer.reply user, email
  end

end
