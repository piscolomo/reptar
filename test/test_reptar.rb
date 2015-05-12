require File.expand_path("../lib/reptar", File.dirname(__FILE__))
require "ostruct"

User = OpenStruct
Post = OpenStruct
Company = OpenStruct

test "single attribute" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  user = User.new(name: "Julio")
  result = {name: "Julio"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

test "nil attribute" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  user = User.new(name: nil)
  result = {name: nil}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

test "multiple attributes" do
  UserReptar = Class.new(Reptar) do
    attributes :name, :email
  end

  user = User.new(name: "Julio", email: "julio@example.com")
  result = {name: "Julio", email: "julio@example.com"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

test "method as attribute" do
  PostReptar = Class.new(Reptar) do
    attribute :slug

    def slug
      "#{name}-#{id}"
    end
  end

  post = Post.new(name: "a-demo-post", id: 1)
  result = {slug: "a-demo-post-1"}.to_json
  assert_equal PostReptar.new(post).to_json, result
end

test "aplying root to single element" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  user = User.new(name: "Julio")
  result = {user: {name: "Julio"}}.to_json
  assert_equal UserReptar.new(user).to_json(root: :user), result
end

test "aplying root to a multiple elements" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  users = [User.new(name: "Julio"), User.new(name: "Piero")]
  result = {
    users: [
      { name: "Julio" },
      { name: "Piero" }
    ]
  }.to_json
  assert_equal UserReptar.new(users).to_json(root: :users), result
end

test "initialize with an array" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  users = [User.new(name: "Julio"), User.new(name: "Piero")]
  
  result = [
    { name: "Julio" },
    { name: "Piero" }
  ].to_json

  assert_equal UserReptar.new(users).to_json, result
end

test "array collection" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    collection :languages
  end

  user = User.new(name: "Julio", languages: ["Ruby", "Js", "Go"])
  
  result = {
    name: "Julio", 
    languages: ["Ruby", "Js", "Go"]
  }.to_json

  assert_equal UserReptar.new(user).to_json, result
end

test "a single representable association" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    attribute :company, with: "CompanyReptar"
  end

  CompanyReptar = Class.new(Reptar) do
    attribute :name
  end
  user = User.new(name: "Julio")
  user.company = Company.new(name: "Codalot")

  result = {
    name: "Julio",
    company: {
      name: "Codalot"
    }
  }.to_json

  assert_equal UserReptar.new(user).to_json, result
end

test "single representable association as nil" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    attribute :company, with: "CompanyReptar"
  end
  user = User.new(name: "Julio")
  user.company = nil

  result = {
    name: "Julio",
    company: nil
  }.to_json

  assert_equal UserReptar.new(user).to_json, result
end

test "array with association" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    attribute :company, with: "CompanyReptar"
  end

  CompanyReptar = Class.new(Reptar) do
    attribute :name
  end

  users = [
    User.new(name: "Julio", company: Company.new(name: "Codalot")),
    User.new(name: "Piero", company: Company.new(name: "Velocis"))
  ]

  result = [
    {
      name: "Julio",
      company: {
        name: "Codalot"
      }
    },
    {
      name: "Piero",
      company: {
        name: "Velocis"
      }
    }
  ].to_json

  assert_equal UserReptar.new(users).to_json, result
end

test "serializes object with collection" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    collection :posts, with: "PostReptar"
  end

  PostReptar = Class.new(Reptar) do
    attribute :title
  end

  user = User.new(name: "Julio")
  user.posts = [
    Post.new(title: "Awesome title"),
    Post.new(title: "Cats are dominating the world right now")
  ]

  result = {
    name: "Julio",
    posts: [
      {
        title: "Awesome title"
      },
      {
        title: "Cats are dominating the world right now"
      }
    ]
  }.to_json

  assert_equal UserReptar.new(user).to_json, result
end

test "array with representable collections" do
  UserReptar = Class.new(Reptar) do
    attribute :name
    collection :posts, with: "PostReptar"
  end

  PostReptar = Class.new(Reptar) do
    attribute :title
  end

  users = [
    User.new(
      name: "Julio",
      posts: [
        Post.new(title: "Hi, I'm a dog")
      ]
    ),
    User.new(
      name: "Piero",
      posts: [
        Post.new(title: "I like turtles"),
        Post.new(title: "Please come back PT!"),
      ]
    )
  ]

  result = [
    {
      name: "Julio",
      posts: [
        {
          title: "Hi, I'm a dog"
        }
      ]
    },
    {
      name: "Piero",
      posts: [
        {
          title: "I like turtles"
        },
        {
          title: "Please come back PT!"
        }
      ]
    }
  ].to_json

  assert_equal UserReptar.new(users).to_json, result
end

test "custom association method" do
  PostReptar = Class.new(Reptar) do
    attribute :title
  end

  UserReptar = Class.new(Reptar) do
    collection :posts, with: "PostReptar"

    def posts
      [Post.new(title: "I like turtles")]
    end
  end

  user = User.new
  result = { posts: [{title: "I like turtles" }] }.to_json
  assert_equal UserReptar.new(user).to_json, result
end