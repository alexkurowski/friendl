class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # Receive an email and decide what to do with it
  def receive
    email = Email.new from:     User.fetch_user_with_address params['sender'], # from field of the mail with the address (my@example.com)
                      subject:  params['subject'], # subject of the mail (should be added as "# subject" [md] to the mail later)
                      body:     params['body'],    # main text of the message
                      no_reply: false,             # no_reply should check the to field of the email here
                      is_reply: (email.body.lstrip[0].in? ['@', '#'])

    # check if mail is bad
    if email.bad?
      email.from.ban
      return close
    end

    email.save

    if email.is_reply
      send_reply email.reply_hash, email
    else
      send_email email.from
    end


    close
  end


  private

  def send_reply reply_hash, email
    reply_email = Email.where(key: reply_hash).take
    unless reply_email.nil?
      reply_user = reply_email.from

      Mailer.reply_to reply_user, email
    end
  end

  def send_email user
    # Find a message that is not a reply
    # that user haven't already received
    reply_email = Email.first

    # and send it to him (now or in a hour)
    Mailer.reply user, reply_email
  end


  def close
    render nothing: true
  end

end
