![](http://cdn.flaticon.com/png/256/33311.png) 
# Gauze

Translating filtering & sorting params to AR scopes can be teadious as doesn't belong in your controllers...

Enter **Gauze**

Gauze allows you to build very simple service objectsm to be called from your controllers and passed the resource & params.

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

Because **Gauze** uses AREL to construct queries, you can use `.build` just like any other scope. You can pass relational objects & chain more relations as you need.
```ruby
def index
  @events = EventFilters.build(current_user.events, params).order(created_at: :desc).where(name: "Football Game")
  render json: @events
end
```

## Contributing

1. Fork it ( https://github.com/TheKidCoder/gauze/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
