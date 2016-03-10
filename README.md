# Dotdiff

Dotdiff is a very basic wrapper around [perceptual-diff](http://pdiff.sourceforge.net/) which works with both Capybara and RSpec to capture and compare the images with a simple rspec matcher. Which can also hide certain elements via executing javascript for elements which can change with different display suchas username or user specific details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotdiff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotdiff

## Usage

First ensure to install perceptualdiff binary which is available via apt-get and brew or via http://pdiff.sourceforge.net/

In your spec/spec_helper
```
require 'dotdiff'
```

If you want the rspec_matcher require the following as well
```
require 'dotdiff/rspec_matcher'
```

In an initializer you can configure certain options example shown below within Dotdiff

```ruby
DotDiff.configure do |config|
  config.perceptual_diff_bin = `which perceptualdiff`.strip
  config.image_store_path = File.expand_path('../../spec/fixtures/images', __FILE__)
  config.js_elements_to_hide = [
    "document.getElementsByClassName('drop-menu-toggle')[0]",
    "document.getElementsById('username-title')",
  ]
  config.failure_image_path = '/home/user/spec_image_failures'

end
```

Basic usage in your spec is just the line below;

```ruby
expect(page).to match_image('GooglePage', subdir: 'Google')
```

It does the following;

It builds the base_image_file location with DotDiff.image_store_path + subdir + filename + .png

It then checks if that file exists;
 - If it doesn't exist it or `resave_base_image` is passed;
    - it hides any elements defined in `js_elements_to_hide`
    - uses `Capybara::Session#save_screenshot` to create a screenshot
    - it then un-hides any elements defined as above
    - returns that compare was successfull

Also if resave_base_image is passed and DotDiff.overwrite_on_resave is false it creates an r2 version so that you can compare with the original or if the file is deleted it will just write the same file.

 - If the `base_image_file` exists and resave_base_image is false;
    - it hides any elements defined in `js_elements_to_hide`
    - uses `Capybara::Session#save_screenshot` to create a screenshot in a tmpdir to compare against the base_image
    - runs the command and observes the result
    - it then un-hides any elements defined as above
    - if failure_image_path is defined it moves the new captured image to that path named as the original file
    - returns both the result and stdout failure message

A failure message might look like the following `expected to match image but failed with: FAIL: Images are 120 pixels visibly different`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jnormington/dotdiff.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Whats left to do

Its not fully completed yet but is usable in its current state.
 - Improve the message output to extract just the fail line
 - Add an integration spec
 - Support multi browser resolutions and handle in the file name
