class Gadget < ActiveRecord::Base
  belongs_to :category
  friendly_identifier :name, :scope => :category_id, :identifier_column => :url_slug

  validates_presence_of :required_stuff
  after_save :something_with_required_stuff
  def something_with_required_stuff
    raise "We need required stuff to be present" if required_stuff.nil?
  end

end