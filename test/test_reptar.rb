require File.expand_path("../lib/reptar", File.dirname(__FILE__))
require "ostruct"

User = OpenStruct
Post = OpenStruct
Company = OpenStruct

test "single attribute to json" do
  UserReptar = Class.new(Reptar) do
    attribute :name
  end

  user = User.new(name: "Julio")
  result = {name: "Julio"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

test "multiple attributes to json" do
  UserReptar = Class.new(Reptar) do
    attributes :name, :email
  end

  user = User.new(name: "Julio", email: "julio@example.com")
  result = {name: "Julio", email: "julio@example.com"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

test "method as attributes to json" do
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