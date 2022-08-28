# ActiveMethod

Refactor your obscure method to a method object with `ActiveMethod`

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add active_method

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install active_method

## Usage

Refactor `Foo#bar` to `Bar` with `ActiveMethod`

```ruby
class Foo
  def bar(a, b, c: , d:)
    puts "a: #{a}"
    puts "b: #{b}"
    puts "c: #{c}"
    puts "d: #{d}"
  end
end
```

Refactor to:

```ruby
class Bar < ActiveMethod::Base
  argument :a
  argument :b, default: 2
  keyword_argument :c
  keyword_argument :d, default: 4

  def call
    puts "a: #{a}"
    puts "b: #{b}"
    puts "c: #{c}"
    puts "d: #{d}"
  end
end

Bar.call(1)
# =>  a: 1
# =>  b: 2
# =>  c: nil
# =>  d: 4

Bar.call(1, 3)
# =>  a: 1
# =>  b: 3
# =>  c: nil
# =>  d: 4

Bar.call(1, 3, c: 6)
# =>  a: 1
# =>  b: 3
# =>  c: 6
# =>  d: 4

Bar.call(1, 3, c: 4, d: 5)
# =>  a: 1
# =>  b: 3
# =>  c: 4
# =>  d: 5
```

## Development

```bash
bundle install
meval rake # Run test
meval -a rake # Run tests against all Ruby versions and Rails versions
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hoppergee/active_method. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hoppergee/active_method/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveMethod project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hoppergee/active_method/blob/master/CODE_OF_CONDUCT.md).
