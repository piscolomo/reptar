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
    hash = {}
    self.class.attributes.each do |name|
      hash[name] = @object.respond_to?(name) ? @object.send(name) : self.send(name)
    end
    hash.to_json
  end
end