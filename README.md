# Terminal

Demo gem which implements point-of-sale scanning  API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terminal', :git => 'git@github.com:malovme/terminal.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terminal

## Usage

```ruby
# Create Terminal instance
terminal = Terminal::Terminal.new
# Set pricing providing hash with amount key and cost value for each product code
terminal.set_pricing({A: {1 => 2, 4 => 7},
                      B: {1 => 12},
                      C: {1 => 1.25, 6 => 6},
                      D: {1 => 0.15}})
terminal.scan('A')
terminal.scan('D')
terminal.total
# => "$ 2.15"

# if you nedd to count next order with same pricing
terminal.next_order

# You able to scan all products at once
terminal.scan('ABCDABAA')
terminal.total
# => "$ 32.40"
```

TODO: Write usage instructions here


