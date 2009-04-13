ActiveRecord::Schema.define(:version => 1) do
	create_table :widgets, :force => true do |t|
		t.column :name, :string
		t.column :friendly_identifier, :string
		t.column :category_id, :integer
	end
	create_table :gadgets, :force => true do |t|
		t.column :name, :string
		t.column :required_stuff, :string
		t.column :url_slug, :string
		t.column :category_id, :integer
	end
	create_table :categories, :force => true do |t|
	  t.column :name, :string
	  t.column :friendly_identifier, :string
	end
end