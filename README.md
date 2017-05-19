# Sidekiq::IdempotentBlock
[![Build Status](https://travis-ci.org/ttasanen/sidekiq-idempotent_block.svg?branch=master)](https://travis-ci.org/ttasanen/sidekiq-idempotent_block)

This is still work in progress and is not ready for production use!

Specify blocks in your Sidekiq workers that should not ever be executed more than once within given worker instance. Sidekiq does great job retrying failed jobs automatically, but this also leads to the fact that you must design your workers to be idempotent. In simple workers this might not be an issue especially when dealing only with database transaction. But in many real life scenarios the workers do really complex stuff and wrapping them in one single database transaction is not possible. 
Furthermore when dealing with external API calls, database like transactions are not available and you must always manually track and store the executed steps since in most cases api calls are note idempotent.

Idempotent_block provides a simple solution for this allowing you to wrap code in blocks that are guaranteed to execute only once with in the context of the given unique job id.


## Installation

This gem is not published yet to Rubygems, but in the mean while you can test it by adding the following to your application's Gemfile

```ruby
gem 'sidekiq-idempotent_block', github: 'ttasanen/sidekiq-idempotent_block'
```

And then execute:

    $ bundle

## Usage

```ruby
class TestWorker
  include Sidekiq::Worker
  include Sidekiq::IdempotentBlock::Worker
  
  def perform(id)
    user = User.find(id)
  
    idempotent_block :my_first_api_call do
      MyApi.really_important_method(user.id)
    end
    
    # ...
  
    idempotent_block :my_second_api_call do
      MyApi.other_method(user.id)
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ttasanen/sidekiq-idempotent_block.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

