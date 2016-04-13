class Dialog < ActiveRecord::Base
  has_and_belongs_to_many :users, -> { uniq }
  has_many :messages
  accepts_nested_attributes_for :messages

  scope :ordering,->{order('created_at DESC')}

  validates :title, presence: true, length: {minimum: 2, maximum: 255}
  validates :users, presence: true, length: {minimum: 2, maximum: 200}

  attr_reader :user_tokens

  def user_tokens=(val)
    self.user_ids = val.split(',')
  end
end
