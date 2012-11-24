# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy
	
	# Convert the user's email to lowercase
	before_save { self.email.downcase! }	

	# Create a remember token
	before_save :create_remember_token

	# Ensure that a User has entered a name that is 50 or less chars long
	validates :name, presence: true, length: { maximum: 50 }

	# Regular Expression to check for a valid email address
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# Ensure that a User has entered an email
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX }, 
					  uniqueness: { case_sensitive: false } 

	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	def feed
		Micropost.where("user_id = ?", id)
	end

	private
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
