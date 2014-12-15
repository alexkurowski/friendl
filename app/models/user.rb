class User < ActiveRecord::Base
  has_many :receives, class_name: "Receive"

  def self.fetch_address mail
    User.where(address: mail).take || User.create(address: mail)
  end
end
