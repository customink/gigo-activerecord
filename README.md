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

TODO: Write usage instructions here


## Contributing

GIGO is fully tested with ActiveRecord 3.0 to 4 and upward. If you detect a problem, open up a github issue or fork the repo and help out. After you fork or clone the repository, the following commands will get you up and running on the test suite. 

```shell
$ bundle install
$ bundle exec rake appraisal:setup
$ bundle exec rake appraisal test
```

We use the [appraisal](https://github.com/thoughtbot/appraisal) gem from Thoughtbot to help us generate the individual gemfiles for each ActiveSupport version and to run the tests locally against each generated Gemfile. The `rake appraisal test` command actually runs our test suite against all Rails versions in our `Appraisal` file. If you want to run the tests for a specific Rails version, use `rake -T` for a list. For example, the following command will run the tests for Rails 3.2 only.

```shell
$ bundle exec rake appraisal:activerecord32 test
```

