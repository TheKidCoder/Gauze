![](http://cdn.flaticon.com/png/256/33311.png) 
# Gauze

Translating filtering & sorting params to AR scopes can be teadious and doesn't belong in your controllers...

Enter **Gauze**

Gauze allows you to build very simple service objects to be called from your controllers and passed the resource & params.

Read on below to see how it works.

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
Define filters & sorters using the Gauze DSL.

The filter method accepts 4 arguments.

`filter :param_key, :column_name, :arel_method, :preprocessor`

* `:param_key` - The key to look for when params are passed in.
* `:column_name` - The name of the column that exists on `ActiveRecord::Base.arel_table`
* `:arel_method` - The AREL method to use in the `where` stanza.
* `:preprocessor` - (Optional) Takes a block to make an changes to the value before its passed into the AREL method. 

```ruby
  class EventFilters < Gauze::Base
    filter :start_range, :created_at, :gteq, -> val {Chronic.parse(val)}
    filter :end_range, :created_at, :lteq, -> val {Chronic.parse(val)}
  end
```

Then in your controller:
```ruby
  class EventsController < ActionController::Base
    def index
      @events = EventFilters.build(Event, params)
      render json: @events
    end
  end
```

The sorter method accepts 2 arguments.

`sorter :param_key, :column_name`


```ruby
  class EventFilters < Gauze::Base
    sorter :event_name, :name
  end
```

Because **Gauze** uses AREL to construct queries, you can use `.build` just like any other scope. You can pass relational objects & chain more relations as you need.
```ruby
def index
  @events = EventFilters.build(current_user.events, params).order(created_at: :desc).where(name: "Football Game")
  render json: @events
end
```

### Using Joins

It is possible to filter & sort across joined tables.

To start, you need to let **Gauze** know that you are going to make use of a join.
Simply add the `needs` method to your gauze classes.

```ruby
  class CustomerFilters < Gauze::Base
    needs :person
  end
```

This can also be a hash or array, a-la activerecord:
```ruby
  needs person: :location, orders: {transaction: :charge}
```

```ruby
  needs :person, :location
```

After you have all of your gauze needs met, you simply use a hash style syntax to filter across the join.
```ruby
  class CustomerFilters < Gauze::Base
    needs :person
    filter :name, {person: :last_name}, :matches, -> val {"%#{val}%"}
    sorter :last_name, {person: :last_name}
  end
```


## TO-DO
- [ ] Write tests.
- [ ] Add controller hooks.
 


## Contributing

1. Fork it ( https://github.com/TheKidCoder/gauze/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
