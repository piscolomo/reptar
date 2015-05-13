# Copyright (c) 2015 Julio Lopez

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
require "json"

class Reptar
  VERSION = "1.0.2"

  class << self; attr_reader :nodes; end

  def self.inherited(klass)
    klass.instance_variable_set("@nodes", {})
  end

  def self.attribute(name, options = {})
    @nodes[name] = options
  end

  def self.attributes(*attributes)
    attributes.each{ |e| @nodes[e] = nil }
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
    @object.respond_to?(:to_a) ? @object.map{|e| self.class.new(e).build_hash } : build_hash
  end

  def build_hash
    self.class.nodes.each_with_object({}) do |(name, options), hash|
      rep = options[:with] if options
      res = @object.respond_to?(name) ? @object.send(name) : self.send(name)
      res = Object.const_get(rep).new(res).representable if rep
      name = options[:key] if options && options[:key]
      hash[name] = res
    end
  end

  class << self; alias_method :collection, :attribute; end
end