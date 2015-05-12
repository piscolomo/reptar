require "json"

class Reptar
  def initialize(object)
    @object = object
  end

  class << self;
    attr_reader :nodes

    def attribute(name)
      @nodes ||= []
      @nodes << name
    end

    def attributes(*attributes)
      @nodes ||= []
      attributes.each{ |e| @nodes << e }
    end
  end

  def method_missing(method_name)
    @object.respond_to?(method_name) ? @object.send(method_name) : super
  end

  def to_json
    return nil unless @object
    self.class.nodes.each_with_object({}) do |name, hash|
      hash[name] = @object.respond_to?(name) ? @object.send(name) : self.send(name)
    end.to_json
  end
end