class Email < ActiveRecord::Base
  belongs_to :from, foreign_key: "from_id", class_name: :User
  has_many :receives

  after_initialize :hash_initialization

  private

  def hash_initialization
    self.key = Digest::SHA1.hexdigest(self.id.to_s)[0...16]
  end
end
