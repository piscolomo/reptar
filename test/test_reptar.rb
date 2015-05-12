require File.expand_path("../lib/reptar", File.dirname(__FILE__))
require "ostruct"

User = OpenStruct
Post = OpenStruct

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