# Yannitor

A simple data preprocessing layer built on top of Active Record.

Currently supported encodings:
* One hot (['Hello', 'dear', 'World'], 'Hello' => [1, 0, 0])
* Min-max normalization ([10, 15, 20] => [0, 0.5, 1])

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yannitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yannitor

## Usage

class Property
  yannitor_features linear: ['area', 'floor', 'floor_count', 'year', 'room_count', 'sale_price'],
                    one_hot: ['building_type', 'building_equipment']
end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvisockas/yannitor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

