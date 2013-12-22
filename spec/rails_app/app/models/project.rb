class Project < ActiveRecord::Base

  has_many :tasks
  validates :subject, presence: true

  def label
    company.present? ? label_with_company : label_without_company
  end

  def formatted_start_at
    start_at.try :to_s, :short
  end

  private
  def label_with_company
    "#{subject} (#{company})"
  end

  def label_without_company
    subject
  end
end