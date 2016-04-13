class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar, styles: {medium: "250x250>", thumb: "60x60>"}

  belongs_to :country
  has_and_belongs_to_many :dialogs
  has_many :messages

ROLES = %w(Пользователь Администратор)

validates :name, presence: true, length: {minimum: 2, maximum: 255}
validates :email, presence: true, uniqueness: {case_sensitive: false},
          format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
validates :role, presence: true, inclusion: {in: 0..ROLES.size}
validates :password, length: {minimum: 6, if: 'password.present?'}, presence: {on: :create}
validates_attachment :avatar, content_type: {content_type: /\Aimage\/.*\z/}

before_validation :set_default_role

scope :ordering,->{order(:name)}

def self.search(query)
  ordering.where("upper(name) like upper(:q)", q: "%#{query}%")
end

def set_default_role
  self.role||=0
end

def role_name
  role && ROLES[role]
end

def admin?
  role == 1
end

def self.by_admin?(u)
  u.try(:admin?)
end

def by_self?(u)
  self == u
end

end
