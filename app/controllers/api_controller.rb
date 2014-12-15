class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # Receive an email and decide what to do with it
  def receive
    email = Email.new

    email.from = User.fetch_user_with_address params['sender'] # from field of the mail with the address (my@example.com)

    email.subject  = params['subject'] # subject of the mail (should be added as "# subject" [md] to the mail later)
    email.body     = params['body']    # main text of the message
    email.no_reply = false             # no_reply should check the to field of the email here
    email.is_reply = (email.body.lstrip[0].in? ['@', '#'])

    # check if mail is bad
    bad_mail email and return close

    email.save

    if email.is_reply
      send_reply get_reply_hash(email.body), email
    else
      send_email email.user
    end


    close
  end


  private

  def get_reply_hash str
    str.lstrip[1...Email::HASH_LENGTH+1]
  end

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

  def bad_mail email
    # return true if mail is bad
    bad = false
    bad = true if email.body.blank?
    bad = true if email.body.length < 100 or email.body.split.length < 20

    ban email.user if bad

    return bad
  end

  def ban user
    user.banned = true
    user.save
  end

  def close
    render nothing: true
  end

end
