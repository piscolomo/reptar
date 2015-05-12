require "json"

class Reptar
  class << self
    attr_reader :nodes

    def attribute(name, options = {})
      @nodes ||= {}
      @nodes[name] = options.fetch(:with, nil)
    end

    def attributes(*attributes)
      @nodes ||= {}
      attributes.each{ |e| @nodes[e] = nil }
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

  def to_json(options = {})
    root = options.fetch(:root, nil)
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