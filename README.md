# AgilecrmRuby

Ruby client for [Agile CRM API](https://www.agilecrm.com).

## Installation

Add to Gemfile:

```gem 'agilecrm_ruby', github: 'Convead/agilecrm_ruby'```

Run `bundle install` to have dependencies installed.

Configure client: 

``` 
AgileCRM.configure do |config|
  config.domain   = "your_domain"
  config.username = "your_username"
  config.apikey   = "your_apikey"
end
```
For Rails project it can be done in `config/initializers/agilecrm.rb` file.

This gem uses [Faraday](https://github.com/lostisland/faraday). To specify which adapter to use add this line to configuration block:

```config.adapter = :your_adapter```

Default is `:net_http`

## Example Usage

```
contact = AgileCRM::Contact.new type: 'COMPANY'
puts contact.type
# => "COMPANY"
contact.type = "PERSON"
puts contact.type
# => "PERSON"

contact.set_property 'first_name', 'Foo'
contact.set_property 'last_name', 'Bar'
contact.add_property 'phone', '123-123-123'
contact.add_property 'phone', '456-456-456'
contact.set_property 'some_custom_property', 'Baz', type: 'CUSTOM'
puts contact.properties
# => [{:name=>"first_name", :value=>"Foo"}, {:name=>"last_name", :value=>"Bar"}, {:name=>"phone", :value=>"123-123-123"}, {:name=>"phone", :value=>"456-456-456"}, {:type=>"CUSTOM", :name=>"some_custom_property", :value=>"Baz"}]

puts contact.id
# => nil
puts contact.persisted?
# => false
puts contact.save
# => true
puts contact.id
# => 123456789
puts contact.persisted?
# => true
```
## Common methods
### Class methods
```
new attributes_hash
assign_attributes attributes_hash
```

### Instance methods
```
save
destroy
persisted?
some_attribute_name
[:some_attribute_name]
some_attribute_name = value
[:some_attribute_name] = value
```

## AgileCRM::Contact Methods
### Class Methods

```
all
```
Returns array of all contacts.
```
find id
find! id
find_by_email email
find_by_email! email
```
Returns contact by its id or email property. The difference between normal and bang versions is that bang-version raises `AgileCRM::Error::ResourceNotFound` if contact doesn't exist.

### Instance methods

```
tags
add_tag tag
add_tags tag1, tag2, ...
remove_tag tag
remove_tags tag1, tag2, ...
clear_tags
has_tag?
```
Tag methods. Self-explanatory.

```
properties
```
Returns array of property hashes.
```
get_properties name, additional_params_to_filter_by = {}
```
Returns array of property hashes filtered by name and optionally other params.
```
get_property name, additional_params_to_filter_by = {}
```
Returns first item from array returned by `get_properties`.
```
get_property_value name, additional_params_to_filter_by = {}
```
Returns value of item returned by `get_property`.
```
has_property? name, value = nil, additional_params_to_filter_by = {}
```
Returns true if contact has property with given name and optionally value and other params. For example, if contact has property `{name: "some_property", value: "some_value", type" "CUSTOM"}`. `has_property?("some_property")`, `has_property?("some_property", "some_value")`, `has_property?("some_property", "some_value", type: "CUSTOM")`, `has_property?("some_property", nil, type: "CUSTOM")` will return true. 
```
add_property name, value, additional_params = {}
```
Appends property to properties array. Should be used for the types of properties which contact may have multiple. Eg phones, emails, website.
```
set_property name, value, additional_params = {}
```
Adds property to properties hash. Unlike `add_property` this method removes all other properties with the same name. Should be used for the types of properties which contact may have only one per property. Eg first_name, last_name.
```
remove_property name, value = nil, additional_params_to_filter_by = {}
```
Removes property by its name and optionally value and other params. For example, `remove_property("some_property")` will remove all properties with the name "some_property", `remove_property("some_property", "some_value")` - only properties with the name "some_property" and value "some_value", `remove_property("some_property", nil, type: "CUSTOM")` - with the name "some_property" and type "CUSTOM", `remove_property("some_property", "some_value", type: "CUSTOM")` - with the name "some_property", value "some_value" and type "CUSTOM".

## AgileCRM::Deal Methods
### Class Methods

```
all
```
Returns array of all deals.
```
find id
find! id
```
Returns deal by its id. The difference between normal and bang versions is that bang-version raises `AgileCRM::Error::ResourceNotFound` if deal doesn't exist.
```
where_contact_email email
```
Returns array of deals related to contact with the given email

## TODO

* Tests
* Notes, Tasks
