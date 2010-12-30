# == Schema Information
# Schema version: 20101229064643
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor   :password # just exists in model object, not db
  attr_accessible :name, :email, :password, :password_confirmation # anything web accessible
  
  has_many :microposts, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z.]+\z/i
  
  validates :name,  :presence => true,
                    :length => { :maximum => 50}
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } 
  validates :password, :presence => true,
                       :confirmation =>true, # automatically creates NAME_confirmation attribute
                       :length => { :within => 6..40 }

  before_save :encrypt_password # callback
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  class << self # anything inside this block becomes a class method (don't need User. or self. in front)
    def authenticate(email, submitted_password) # in this case = User.authenticate
      user = find_by_email(email)
      (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  private 
  
    def encrypt_password
      self.salt = make_salt if new_record? # only make salt if this is a new record
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
