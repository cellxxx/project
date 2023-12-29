# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def update_last_login_at
    self.last_login_at = DateTime.now
    save
  end
end
