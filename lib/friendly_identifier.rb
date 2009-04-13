require 'active_record'

module BeyondThePath
  module Plugins
    module FriendlyIdentifier #:nodoc:
      
      mattr_accessor :identifier_options

      def self.included(mod)
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def friendly_identifier(source, options = {})
          
          # Merge with default options
          class_inheritable_accessor :identifier_options
          self.identifier_options = {
            :keep_updated => true,
            :identifier_column => :friendly_identifier
          }.merge(options)
          
          # Include/override class methods and object instance methods
          include BeyondThePath::Plugins::FriendlyIdentifier::InstanceMethods
          class_eval do
            extend BeyondThePath::Plugins::FriendlyIdentifier::SingletonMethods
          end
          
          # Identifier must be present, otherwise what's the point?
          validates_presence_of identifier_options[:identifier_column]
          
          # Identifiers should be unique in their given scope
          validates_uniqueness_of identifier_options[:identifier_column],
                                  :scope => (identifier_options[:scope])
          
          # Update the identifier, #set_identifier! figures out when
          before_validation { |record| record.set_identifier!(source) }
          
        end
      end
      
      # Adds class methods.
      module SingletonMethods
       
        def friendly_identifier?(id)
          id.is_a?(String) && id.to_i.to_s != id
        end

        def find(*args)
          if friendly_identifier? args.first
            super(:first, :conditions => ["#{identifier_options[:identifier_column]} = ?", args.first])
          else
            super
          end
        end

        def format_identifier(s)
          s.gsub!(/'/,'') # remove characters that occur mid-word
          s.gsub!(/[\W]/,' ') # translate non-words into spaces
          s.strip! # remove spaces from the ends
          s.gsub!(/\ +/,'-') # replace spaces with hyphens
          s.downcase # lowercase what's left
        end

      end

      # Adds instance methods.
      module InstanceMethods

        def set_identifier!(source)
          source_column = source.to_s
          identifier_column = identifier_options[:identifier_column].to_s
          if identifier_options[:keep_updated] or self[identifier_column].blank?
            if self[source_column]
              self[identifier_column] = self.class.format_identifier(self[source_column].to_s.dup)
            end
          end
        end
        
        def to_param
          self[identifier_options[:identifier_column]]
        end
        
      end

    end
  end
end
