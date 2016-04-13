class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :dialog

  validates :user, presence: true
  validates :content, presence: true
end
