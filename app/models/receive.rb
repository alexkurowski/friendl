class Receive < ActiveRecord::Base
  belongs_to :user
  belongs_to :email
end
