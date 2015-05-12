Reptar
====

Microlibrary for write representations of objects to your JSON APIs.

## Introduction



## Installation

Installing Reptar is as simple as running:

```
$ gem install reptar
```

Include Reptar in your Gemfile with gem 'reptar' or require it with require 'reptar'.

Usage
-----

## Attributes

Inherit Reptar to build your representation, initialize your Reptar class with your object and get your json output with `to_json`. Declare the fields you want to return with `attribute`

```ruby
UserReptar < Reptar
  attribute :name
end

user = User.new(name: "Julio")
UserReptar.new(user).to_json
# => "{\"name\":\"Julio\"}"
```

You can define multiple attributes with `attributes`

```ruby
UserReptar < Reptar
  attributes :first_name, :last_name, :email
end

user = User.new(name: "Julio", last_name: "Piero", email: "julio@example.com")
UserReptar.new(user).to_json

{
  "first_name": "Julio",
  "last_name": "Piero",
  "email": "julio@example.com"
}
```

