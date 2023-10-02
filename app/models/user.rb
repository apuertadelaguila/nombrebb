class User < ApplicationRecord
  has_many :votacions

  validates :nombre, :password, :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: true

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def has_role?(roles)
    self.roles.where(name: roles).any?
  end

  def has_vote_for_bb?(bebe_id)
    self.votacions.where(bebe_id: bebe_id).any?
  end
end
