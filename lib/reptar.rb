require "json"

class Reptar
  class << self
    attr_reader :nodes

    def attribute(name)
      @nodes ||= []
      @nodes << name
    end

    def attributes(*attributes)
      @nodes ||= []
      attributes.each{ |e| @nodes << e }
    end

    def method_missing(method_name, *args)
      method_name == :collection ? self.send(:attribute, *args) : super
    end
  end

  def initialize(object)
    @object = object
  end

  def method_missing(method_name)
    @object.respond_to?(method_name) ? @object.send(method_name) : super
  end

  def to_json
    return nil unless @object
    h = @object.is_a?(Array) ? @object.map{|e| self.class.new(e).hasheable } : hasheable
    h.to_json
  end

  def hasheable
    self.class.nodes.each_with_object({}) do |name, hash|
      hash[name] = @object.respond_to?(name) ? @object.send(name) : self.send(name)
    end
  end
end