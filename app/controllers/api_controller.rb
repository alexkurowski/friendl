class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # Receive an email and decide what to do with it
  def receive
    email = Email.new from:     User.fetch_user_with_address(params['from']), # from field of the mail with the address (my@example.com)
                      subject:  params['subject'], # subject of the mail (should be added as "# subject" [md] to the mail later)
                      body:     params['stripped-text'],    # main text of the message
                      no_reply: false,             # no_reply should check the to field of the email here
                      is_reply: (params['stripped-text'].lstrip[0].in? ['@', '#'])

    # check if mail is bad
    if email.bad?
      email.from.ban
      return close
    end

    email.save

    if email.is_reply
      Mailer.send_reply email.reply_hash, email
    else
      Mailer.send_email email.from
    end


    close
  end


  private

  def close
    render nothing: true
  end

end
