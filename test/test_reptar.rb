require File.expand_path("../lib/reptar", File.dirname(__FILE__))
require "ostruct"

User = OpenStruct
Post = OpenStruct

class UserReptar < Reptar
  attribute :name
end

test "attributes to json" do
  user = User.new(name: "Julio")
  result = {name: "Julio"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end

class PostReptar < Reptar
  attribute :slug

  def slug
    "#{name}-#{id}"
  end
end

test "methods as attributes to json" do
  post = Post.new(name: "a-demo-post", id: 1)
  result = {slug: "a-demo-post-1"}.to_json
  assert_equal PostReptar.new(post).to_json, result
end