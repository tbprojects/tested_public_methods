Tested Public Methods [![Build Status](https://travis-ci.org/tbprojects/tested_public_methods.png)](https://travis-ci.org/tbprojects/tested_public_methods) [![Code Climate](https://codeclimate.com/github/tbprojects/tested_public_methods.png)](https://codeclimate.com/github/tbprojects/tested_public_methods)
=================

Returns list of public methods that do not have their own unit tests.
Gem checkes classes in app directory againts tests in spec directory.
Checkout http://betterspecs.org to learn expected conventions in specs.

## Installation:
```gem install tested_public_methods```

or

```gem 'tested_public_methods'``` in your Gemfile

## Usage & Example

Execute ```rake tested_public_methods:analyze``` to list all untested methods or classes.

Example of an output:
```
* missing spec file for User
* missing test for Task#project_name
* missing test for Task.with_description
* missing test for Project#formatted_start_at
* missing test for ProjectsController#index

Found 5 issues
```

## Configuration

Sometimes you may need to skip some classes or methods during analysis. In order to do that
generate initializer with ```rails generate initializer tested_public_methods``` and fill
configuration (config.skip_classes and config.skip_methods) according to the example.

## Tests
Module is tested with rspec. To run it just execute ```rake```

## Credits
[Tomasz Borowski](http://tbprojects.pl)