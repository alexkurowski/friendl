class Email < ActiveRecord::Base
  belongs_to :from, foreign_key: "from_id", class_name: :User
  has_many :receives

  after_create :initialization

  HASH_LENGTH = 12


  def was_sent
    self.sent = self.sent + 1
    save
  end

  private

  def initialization
    self.key = Digest::SHA1.hexdigest(self.id.to_s)[0...HASH_LENGTH]

    compose

    save
  end

  def compose
    @markdown ||= Redcarpet::Markdown.new Redcarpet::Render::HTML

    self.body = ActionView::Base.full_sanitizer.sanitize self.body
    self.body = @markdown.render self.body

    unless self.no_reply
      self.body = "<p id='hash'>##{self.key}</p>" << self.body
    end
    unless self.subject.blank?
      self.body = "<h1>#{self.subject}</h1>" << self.body
    end
  end
end
