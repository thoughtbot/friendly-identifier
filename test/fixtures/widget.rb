class Widget < ActiveRecord::Base
  belongs_to :category
  friendly_identifier :name, :scope => :category_id
end