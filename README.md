Tested Public Methods
=================

Returns list of public methods that do not have their own unit tests.
Gem checkes classes in app directory againts tests in spec directory.
Checkout http://betterspecs.org to learn expected conventions in specs.

## Installation:
```gem install tested_public_methods```

or

```gem 'tested_public_methods'``` in your Gemfile

## Usage & Example

Execute ```TestedPublicMethods::Detector.new.analyze``` to list all untested methods or classes.

Example of an output:
```
* missing spec file for User
* missing test for Task#project_name
* missing test for Task.with_description
* missing test for Project#formatted_start_at
* missing test for ProjectsController#index

Found 5 issues
```

## Tests
Module is tested with rspec. To run it just execute ```rake```

## Credits
[Tomasz Borowski](http://tbprojects.pl)