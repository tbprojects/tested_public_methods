class Task < ActiveRecord::Base

  belongs_to :project
  validates :name, presence: true

  delegate :name, to: :project, prefix: true

  def task_label
    "#{name}: #{description}"
  end

  def self.without_description
    where(description: nil)
  end

  def self.with_description
    where.not(description: nil)
  end
end