class User < ActiveRecord::Base
  has_many :receives, class_name: "Receive"
end
