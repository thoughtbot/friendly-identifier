class Category < ActiveRecord::Base
  friendly_identifier :name, :keep_updated => false
  has_many :widgets
  has_many :gadgets
end