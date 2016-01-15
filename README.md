# JTRailsTokenizable

[![Gem Version](https://badge.fury.io/rb/jt-rails-tokenizable.svg)](http://badge.fury.io/rb/jt-rails-tokenizable)

JTRailsTokenizable generates tokens for ActiveRecord models in Ruby On Rails.

## Installation

JTRailsTokenizable is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

    gem 'jt-rails-tokenizable', '~> 1.0'

## Usage

### Basic usage

```ruby
class User < ActiveRecord::Base
	tokenize :my_token_field
	tokenize :another_token_field, size: 20, validations: false
	tokenize :another_token_field, size: 20, only_digits: true
	...
end
```

You can change the size of the token (32 by default, which means 64 caracters) and disable the presence and uniqueness validations. The generation of token is using `SecureRandom.hex` or `SecureRandom.random_number` methods.

A new unique token is generated at the creation of the model. You can generate a new token with:

```ruby
my_instance.generate_new_token(:my_token_field)
my_instance.save
```

## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

JTRailsTokenizable is released under the MIT license. See the LICENSE file for more info.
