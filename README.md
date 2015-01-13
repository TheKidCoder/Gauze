# Gauze

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gauze'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gauze

## Usage

Create a class that your controller can find.
Define filters using the Gauze DSL.

The filter method accepts 4 arguments.
`filter :param_key, :column_name, :arel_method, :preprocessor`

* `:param_key` - The key to look for when params are passed in.
* `:column_name` - The name of the column that exists on `ActiveRecord::Base.arel_table`
* `:arel_method` - The AREL method to use in the `where` stanza.
* `:preprocessor` - (Optional) Takes a block to make an changes to the value before its passed into the AREL method. 

```ruby
  class EventFilters < Gauze::Base
    filter :start_range, :created_at, :gteq, -> val {Chronic.parse(val)}
  end
```

## Contributing

1. Fork it ( https://github.com/TheKidCoder/gauze/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
