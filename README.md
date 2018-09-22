# Blog-Ruby on Rails

A simple blog application on rails.

## Deploy to Heroku

### Installation

```
  $ sudo snap install --classic heroku
```

### Login & Add SSH key

```
  $ heroku login
  $ heroku keys:add
```

### Push to heroku

```
  $ git push heroku master
```

### Open browser by URL or command

```
  $ heroku open
```

### Rename host name

Name must start with a letter and can only contain lowercase letters, numbers, and dashes.

```
  $ heroku rename <host-name>
```

### Initial database on heroku

For heroku, it required the postgresql for database. We need to add a gem for postgresql in production.
Move the sqlite3 to development and test.

```
group :production do
  gem 'pg', '0.20.0'
end
```

We need to update the gem file

```
  $ bundle install --without production
```

After that, migrate the database on Heroku

```
  $ heroku run rails db:migrate
```

## Advanced testing

### Installation
Add the required gem in test

```
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
```

### Minitest reporters
To get the default Rails tests to show red and green at the appropriate times

Add two line to test/test_helper.rb

```
require "minitest/reporters"
Minitest::Reporters.use!

```

### Automated tests with Guard
To avoid this inconvenience, we can use Guard to automate the running of the tests. Guard monitors changes in the filesystem so that, for example, when we change the static_pages_controller_test.rb file, only those tests get run. Even better, we can configure Guard so that when, say, the home.html.erb file is modified, the static_pages_controller_test.rb automatically runs.

```
  $ bundle exec guard init
```

Modify the GuardFile

```
# Defines the matching rules for Guard.
guard :minitest, spring: "bin/rails test", all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch('config/routes.rb')    { integration_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    "test/models/#{matches[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    ["test/controllers/#{matches[1]}_controller_test.rb"] +
    integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch('app/views/layouts/application.html.erb') do
    'test/integration/site_layout_test.rb'
  end
  watch('app/helpers/sessions_helper.rb') do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end
  watch('app/controllers/sessions_controller.rb') do
    ['test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb']
  end
  watch('app/controllers/account_activations_controller.rb') do
    'test/integration/users_signup_test.rb'
  end
  watch(%r{app/views/users/*}) do
    resource_tests('users') +
    ['test/integration/microposts_interface_test.rb']
  end
end

# Returns the integration tests corresponding to the given resource.
def integration_tests(resource = :all)
  if resource == :all
    Dir["test/integration/*"]
  else
    Dir["test/integration/#{resource}_*.rb"]
  end
end

# Returns the controller tests corresponding to the given resource.
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# Returns all tests for the given resource.
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end
```

To prevent conflicts between Spring and Git when using Guard, you should add the spring/ directory to the .gitignore file used by Git to determine what to ignore when adding files or directories to the repository.

```
# Ignore Spring files.
/spring/*.pid
```

Open a new terminal, run the command and leave it

```
  $ bundle exec guard
```

## Beauty layout by Bootstrap

Add bootstrap-sass gem into Gemfile

```
gem 'bootstrap-sass', '3.3.7'
```

Run this command to install the Bootstrap

```
  $ bundle install
```

In order to use the bootstrap, we need to import it. Create a 'custom.scss' in 'app/assets/stylesheets' and copy the code below

```
@import "bootstrap-sprockets";
@import "bootstrap";
```

### Layout Link Test

```
  $ rails generate integration_test site_layout
```
