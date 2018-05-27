class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  # проверки выполняются только если user не задан (незарегистрированные приглашенные)

  validate :user_exist?, on: :create
  validates :user_name, presence: true, unless: 'user.present?'
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: 'user.present?'

  validates :user, uniqueness: {scope: :event_id}, if: 'user.present?'
  validates :user_email, uniqueness: {scope: :event_id}, unless: 'user.present?'

  def find_user_by_email
    :user_email == User.find_by(email: :user_email)
  end

  def user_exist?
    if user_id.blank? && find_user_by_email
      errors.add(:user_email, 'Пользователь с таким email уже зарегистрирован')
    end
  end

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end
end
