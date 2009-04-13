puts <<EOT

friendly_identifier

  A Rails ActiveRecord plugin that lets you make human readable URLs using
  "friendly" identifiers.

Usage:

  friendly_identifier(source_column, options)

Examples:

  class Person < ActiveRecord::Base
    friendly_identifier :name
  end

  class LegacyWidget < ActiveRecord::Base
    friendly_identifier :name, :scope => :category_id, :identifier_column => :url_slug

    # you can override the format_identifier callback
    def self.format_identifier(str)
      s.downcase.gsub(/'/,'').gsub(/\W/,' ').strip.gsub(/ +/, '_')
    end
  end

Options:

  * :keep_updated - Change the identifier whenever the field it is based on is
    changed. Defaults to true, but set to false if you need your identifiers
    to be customizable or URLs to remain unchanged after creation.

  * :scope - Passed on to validates_uniqueness_of :friendly_identifier.

  * :identifier_column - Pass in the name of an existing column you already
    have defined and would like to reuse for the same sort functionality.

  * You can override the format_identifier class method to match your own
    preferred filtering style. Say, by using underscores instead of dashes.


Requirements:

  * Your models simply need a string column named "friendly_identifier".

Feedback welcome. See the README for commentary, caveats, and contact info.
EOT