require 'friendly_identifier'

ActiveRecord::Base.class_eval do
  include BeyondThePath::Plugins::FriendlyIdentifier
end
