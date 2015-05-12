require "json"

class Reptar
  def initialize(object)
    @object = object
  end

  class << self;
    attr_reader :attributes

    def attribute(name)
      @attributes ||= []
      @attributes << name
    end
  end

  def method_missing(method_name)
    @object.respond_to?(method_name) ? @object.send(method_name) : super
  end

  def to_json
    return nil unless @object
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = @object.respond_to?(name) ? @object.send(name) : self.send(name)
    end.to_json
  end
end