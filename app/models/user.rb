require 'digest/sha2'

class User < ActiveRecord::Base
  validates     :name, :presence => true, :uniqueness => true
  validates     :password, :confirmation => true
  attr_accessor :password, :password_confirmation

  validate      :password_must_be_present
  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  class << self
    def authenticate(name, password)
      if user = find_by_name(name)
        if user.hashed_password == encrypt_password(password, user.salt)
        user
        end
      end
    end

    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end
  end

  private

  def update_hashed_password
    if self.password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def password_must_be_present
    errors.add(:password, "Missing password" ) unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
