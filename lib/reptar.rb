require "json"

class Reptar
  class << self; attr_reader :nodes; end

  def self.inherited(klass)
    klass.instance_variable_set("@nodes", {})
  end

  def self.attribute(name, options = {})
    @nodes[name] = options[:with]
  end

  def self.attributes(*attributes)
    attributes.each{ |e| @nodes[e] = nil }
  end

  def self.method_missing(method_name, *args)
    method_name == :collection ? self.send(:attribute, *args) : super
  end

  def initialize(object)
    @object = object
  end

  def method_missing(method_name)
    @object.respond_to?(method_name) ? @object.send(method_name) : super
  end

  def to_json(options = {})
    root = options[:root]
    (root ? { root => representable } : representable).to_json
  end

  def representable
    return nil unless @object
    @object.is_a?(Array) ? @object.map{|e| self.class.new(e).build_hash } : build_hash
  end

  def build_hash
    self.class.nodes.each_with_object({}) do |(name, rep), hash|
      res = @object.respond_to?(name) ? @object.send(name) : self.send(name)
      res = Object.const_get(rep).new(res).representable if rep
      hash[name] = res
    end
  end
end