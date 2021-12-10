class User < ApplicationRecord
  attr_accessor :current_password

  validates :name, presence: true, uniqueness: true

  validates :password, presence: true, on: :update

  has_secure_password

  after_destroy :ensure_an_admin_remains

  validate :current_password_is_correct, on: :update

  class Error < StandardError
  end

  private

    def current_password_is_correct
      if User.find(id).authenticate(current_password) == false
        errors.add(:current_password, "is incorrect.")
      end
    end

    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

end
