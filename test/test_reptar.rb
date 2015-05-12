require File.expand_path("../lib/reptar", File.dirname(__FILE__))
require "ostruct"

User = OpenStruct

class UserReptar < Reptar
  attribute :name
end

test "attributes to json" do
  user = User.new(name: "Julio")
  result = {name: "Julio"}.to_json
  assert_equal UserReptar.new(user).to_json, result
end