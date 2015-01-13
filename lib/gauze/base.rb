module Gauze
  class Base
    def self.filter(param_key, column_name, arel_method, preprocessor = nil)
      @@filters ||= []
      @@filters.push param_key: param_key, column: column_name, method: arel_method, preprocessor: preprocessor
    end

    def self.build(resource, params = {})
      new(resource, params).build_nodes
    end

    def initialize(resource, params = {})
      @resource = resource
      @params = params.symbolize_keys
    end

    def build_nodes
      wheres = applied_filters.map {|obj| build_arel_filter(obj)}
      _query = @resource
      wheres.each {|node| _query = _query.where(node)}
      return _query
    end

    def build_arel_filter(filter_hash)
      filter_val = @params[filter_hash[:param_key]]
      filter_val = filter_hash[:preprocessor].call(filter_val) if filter_hash[:preprocessor]

      @resource.arel_table[filter_hash[:column]].method(filter_hash[:method]).call(filter_val)
    end

    private
    def applied_filters
      _filters = []
      @params.each do |k,v|
        next unless v.present?
        next unless filter = @@filters.find {|obj| obj[:param_key] == k}
        _filters.push filter
      end

      _filters
    end
  end
end