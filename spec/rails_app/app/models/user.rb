class User < ActiveRecord::Base

  validates :name, :email, presence: true

  def label
    "#{name} (#{email})"
  end

end