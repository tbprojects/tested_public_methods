require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :projects, :force => true do |t|
    t.column :subject, :string
    t.column :company, :string
    t.column :summary, :text
    t.column :priority, :integer
    t.column :start_at, :date
  end

  create_table :tasks, :force => true do |t|
    t.column :name, :string
    t.column :description, :text
    t.column :project_id, :integer
    t.column :due_date, :date
  end

  create_table :users, :force => true do |t|
    t.column :email, :string
    t.column :name, :string
  end
end