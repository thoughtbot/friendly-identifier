require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'fixtures/widget')
require File.join(File.dirname(__FILE__), 'fixtures/category')
require File.join(File.dirname(__FILE__), 'fixtures/gadget')

class FriendlyIdentifierTest < Test::Unit::TestCase
  
  def test_create_valid_default_objects
    assert_valid create_widget
    assert_valid create_gadget
    assert_valid create_category
  end
  
  def test_should_be_set_on_create
    widget = create_widget
    assert_not_nil widget.friendly_identifier, "Friendly identifier column not set on create"
    assert_equal widget.friendly_identifier, widget.to_param, "Friendly identifier should be the value of to_param"
  end
  
  def test_must_be_unique_in_same_scope
    t = "Same Name, Same Category"
    widget1 = create_widget(:name => t)
    widget2 = create_widget(:name => t)
    assert !widget2.valid?, "Friendly identifiers must be unique in the same scope"
  end
  
  def test_should_allow_duplicates_in_different_scopes
    t = "Same Name, Different Category"
    widget1 = create_widget(:name => t, :category_id => 1)
    widget2 = create_widget(:name => t, :category_id => 2)
    assert widget2.valid?, "Duplicate friendly identifiers should be allowed in different scopes"
  end
  
  def test_should_update_on_change
    widget = create_widget
    widget.update_attributes(:name => "Bar")
    assert_equal "bar", widget.friendly_identifier, "Friendly identifier did not get updated"
  end
  
  def test_optionally_should_not_update_on_change
    category = create_category
    previous_identifier = category.friendly_identifier
    category.update_attributes(:name => "Category B")
    assert_equal previous_identifier, category.friendly_identifier, "Friendly identifier was changed even though it shouldn't have been"
  end
  
  def test_explicitly_given_value_should_take_precedence_on_create
    # Actually we're going to leave this undefined for now...
    # This is only really clear to me for updates where :keep_updated => true
  end
  
  def test_explicitly_given_value_should_take_precedence_on_create
    # Left undefined for now, as per the above
  end
  
  def test_should_allow_user_configurable_identifier_column
    gadget = create_gadget
    assert_not_nil gadget.url_slug, "Friendly identifier column should be user configurable"
    assert_equal gadget.url_slug, gadget.to_param, "Friendly identifier is not returning the value stored in a custom identifier column"
    assert_not_nil (g = Gadget.find(gadget.to_param)), "Can't find an object with a different identifier column"
    assert_equal gadget.name, g.name, "Gadget we found is not the same as the one we want"
  rescue ActiveRecord::StatementInvalid
    flunk "Can't find an object with a different identifier column"
  end

  def test_should_also_allow_object_to_be_found_by_id
    gadget = create_gadget(:name => "new name")
    assert_not_nil gadget.url_slug
    assert gadget.save, "Couldn't save object #{gadget.errors.inspect}"
    assert_not_nil (g = Gadget.find(gadget.id)), "Can't find an object by id"
    assert_equal gadget.name, g.name, "Gadget we found is not the same as the one we want"
  end

  def test_should_also_allow_object_to_be_found_by_string_id
    gadget = create_gadget(:name => "test name")
    assert_not_nil gadget.url_slug
    assert gadget.save, "Couldn't save object #{gadget.errors.inspect}"
    assert_not_nil (g = Gadget.find(gadget.id.to_s)), "Can't find an object by id"
    assert_equal gadget.name, g.name, "Gadget we found is not the same as the one we want"
  end

  def test_should_not_mess_with_validations_and_after_save
    gadget = create_gadget :required_stuff => nil
    assert !gadget.valid?
  rescue
    flunk "We're forcing a save when we shouldn't be"
  end
  
  def test_should_perform_strict_redirects
    # Maintain a history of identifiers and perform a 301 redirect for old ones
    # I think this might require a separate table, or at least an extra column
  end
  
  def test_should_format_nicely
    w = create_widget :name => "Nick's test du-jour!"
    assert_equal "nicks-test-du-jour", w.to_param
    w = create_widget :name => 'a!@#$b%^&*()c'
    assert_equal 'a-b-c', w.to_param
  end
  
  def test_should_handle_weird_strings_nicely
    w = create_widget :name => "ice".freeze rescue flunk
    w = create_widget :name => :test_symbols rescue flunk "Exception when passing a symbol"
  end
  
  def test_should_not_ever_modify_source_column
    name = "Can't touch this"
    w = create_widget :name => name
    assert_equal name, w.name
    w.update_attributes(:name => name)
    assert_equal name, w.name
  end
  
  def test_should_play_nice_with_chumby
    w = create_widget :name => 'Chumby Analog Clock (white)'
    assert_equal 'chumby-analog-clock-white', w.to_param
  end
  
private

  def create_widget(options={})
    Widget.create({
      :name => "Fooriffic Widget",
      :category_id => 1
    }.merge(options))
  end
  
  def create_category(options={})
    Category.create({
      :name => "Categlorious Assemblage"
    }.merge(options))
  end
  
  def create_gadget(options={})
    Gadget.create({
      :name => "Gadgetacular Gadget",
      :required_stuff => "required"
    }.merge(options))
  end
  
  def assert_valid(obj)
    assert obj.valid?, "#{obj.class.to_s} is not valid: #{obj.errors.full_messages.join(', ')}"
  end

end
