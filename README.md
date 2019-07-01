# GIGO (Garbage In, Garbage Out) For ActiveRecord

See the [GIGO](http://github.com/customink/gigo) project for general information.


## Installation

Add this line to your application's Gemfile:

    gem 'gigo-activerecord'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gigo-activerecord


## Usage

#### Column Helpers

This gem allows you to use GIGO with ActiveRecord in a few convenient ways. First by easily declaring that a column should be loaded through GIGO. Assuming you have a `Note` model with a `subject` column.

```ruby
class Note < ActiveRecord::Base
  gigo_column :subject
end

@note.subject # => "€20 – “Woohoo”"
```

GIGO extends your model in such a way that still allows you to define your own instance methods and super up through the attribute method stack.

```ruby
class Note < ActiveRecord::Base
  gigo_column :subject
  def subject
    super.upcase
  end
end

@note.subject # => "€20 – “WOOHOO”"
```

If you want to extend all `:string` and `:text` columns, use the `gigo_columns` method. All string/text columns will be GIGO'ized. Any arguments passed to `gigi_columns` will be excluded.

```ruby
class LegacyTable < ActiveRecord::Base
  gigo_columns
end
```

#### Serialized Attributes

Sometimes your serialized attributes need GIGO before loading the YAML.

```ruby
class Order < ActiveRecord::Base
  serialize :notes, gigo_coder_for(Hash)
end
```


## Contributing

GIGO is fully tested with ActiveRecord 3.0 to 4 and upward. If you detect a problem, open up a github issue or fork the repo and help out. After you fork or clone the repository, the following commands will get you up and running on the test suite.

```shell
$ bundle install
$ bundle exec appraisal install
$ bundle exec appraisal rake test
```

We use the [appraisal](https://github.com/thoughtbot/appraisal) gem from Thoughtbot to help us generate the individual Gemfiles for each ActiveSupport version and to run the tests locally against each generated Gemfile. The `rake appraisal test` command actually runs our test suite against all Rails versions in our `Appraisal` file. If you want to run the tests for a specific Rails version, use `rake -T` for a list. For example, the following command will run the tests for Rails 3.2 only.

```shell
$ bundle exec appraisal activerecord50 rake test
```
