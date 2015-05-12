Reptar
====

Microlibrary for write representations of objects to your JSON APIs.

![Reptar](http://vignette3.wikia.nocookie.net/godzilla/images/4/4c/Reptar.png)

## Installation

Installing Reptar is as simple as running:

```
$ gem install reptar
```

Include Reptar in your Gemfile with gem 'reptar' or require it with require 'reptar'.

Usage
-----

### Attributes

Inherit `Reptar` to build your representation, initialize your Reptar class with your object and get your json output with `to_json`. Declare the fields you want to return with `attribute`

```ruby
class UserRep < Reptar
  attribute :name
end

user = User.new(name: "Julio")
UserRep.new(user).to_json
# => "{\"name\":\"Julio\"}"
```

You can define multiple attributes with `attributes`

```ruby
class UserRep < Reptar
  attributes :first_name, :last_name, :email
end

user = User.new(first_name: "Julio", last_name: "Piero", email: "julio@example.com")
UserRep.new(user).to_json

# => The json output is:
{
  "first_name": "Julio",
  "last_name": "Piero",
  "email": "julio@example.com"
}
```

If you want to rename an attribute to send a different name in the json output you can use the `key` option.

```ruby
class UserRep < Reptar
  attribute :name
  attribute :city, key: :location
end

user = User.new(name: "Julio", city: "Lima")
UserRep.new(user).to_json

# => The json output is:
{
  "name": "Julio",
  "location": "Lima"
}
```

### Methods

Send your custom methods as attributes to return their results to the json output.

```ruby
class PostRep < Reptar
  attributes :title, :slug

  def slug
    title.downcase.gsub(' ', '-')
  end
end

post = Post.new(title: "My awesome post")
PostRep.new(post).to_json

# => The json output is:
{
  "title": "My awesome post",
  "slug": "my-awesome-post"
}
```

### Set your root

You can specify a root for prepend a keyname to your ouput, use the `root` option for that.

```ruby
UserRep.new(user).to_json(root: :user)
# => The json output is:
{ 
  "user": {
    "first_name": "Julio",
    "last_name": "Piero",
    "email": "julio@example.com"
  }
}
```

### Start with an array

You can initialize your representation class with an array of objects to return the output of each one.

```ruby
class UserRep < Reptar
  attributes :name
end

user1 = User.new(name: "Julio")
user2 = User.new(name: "Abel")
user3 = User.new(name: "Piero")
users = [user1, user2, user3]
UserRep.new(users).to_json

# => The json output is:
[
  { name: "Julio" },
  { name: "Abel" },
  { name: "Piero" }
]
```

### Collections

`collection` method is available to be more explicit in your representation.

```ruby
class UserRep < Reptar
  attribute :name
  collection :languages
end

user = User.new(name: "Julio", languages: ["Ruby", "Js", "Go"])
UserRep.new(user).to_json

# => The json output is:
{
  name: "Julio", 
  languages: ["Ruby", "Js", "Go"]
}
```

### Associations

You can associate your representation class with another using the `with` option, this is useful for return a nested output.

```ruby
class UserRep < Reptar
  attributes :name, :email
  attribute :company, with: "CompanyRep"
end

class CompanyRep < Reptar  
  attributes :name, :city
end

user = User.new(name: "Julio", email: "julio@example.com")
user.company = Company.new(name: "Codalot", city: "Lima")
UserRep.new(user).to_json

# => The json output is:
{
  name: "Julio",
  email: "julio@example.com",
  company: {
    name: "Codalot",
    city: "Lima"
  }
}
```

You are free to also use `collection for define your asocciations.

```ruby
class UserRep < Reptar
  attributes :name, :email
  collection :posts, with: "PostRep"
end

class PostRep < Reptar
  attributes :title, :content
end

user = User.new(name: "Julio", email: "julio@example.com")
user.posts << Post.new(title: "Awesome title 1", content: "lorem lipsum")
user.posts << Post.new(title: "Awesome title 2", content: "lorem lipsum")
user.posts << Post.new(title: "Awesome title 3", content: "lorem lipsum")
UserRep.new(user).to_json

# => The json output is:
{
  name: "Julio",
  email: "julio@example.com",
  posts: [
    {
      title: "Awesome title 1",
      content: "lorem lipsum"
    },
    {
      title: "Awesome title 2",
      content: "lorem lipsum"
    },
    {
      title: "Awesome title 3",
      content: "lorem lipsum"
    }
  ]
}
```
