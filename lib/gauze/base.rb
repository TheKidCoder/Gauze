module Gauze
  class Base
    def self.needs(*join_stanza)
      @join_stanza ||= nil
      case @join_stanza
      when nil
        @join_stanza = join_stanza
      when Array
        @join_stanza.push(join_stanza)
      when Hash
        @join_stanza.merge!(join_stanza)
      end
    end

    def self.filter(param_key, column_name, arel_method, preprocessor = nil)
      @filters ||= []
      @filters.push param_key: param_key, column: column_name, method: arel_method, preprocessor: preprocessor
    end

    def self.sorter(param_key, column)
      @sorters ||= []
      @sorters.push param_key: param_key, column: column
    end

    def self.build(resource, params = {})
      new(resource, params).build
    end

    def initialize(resource, params = {})
      @resource = resource
      @params = params.symbolize_keys
    end

    def build
      wheres = applied_filters.map {|obj| build_arel_filter(obj)}
      _query = @resource
      wheres.each {|node| _query = _query.where(node)}

      if get_klass_var(:@join_stanza).present?
        _query = _query.joins(get_klass_var(:@join_stanza))
      end

      if get_klass_var(:@sorters).present?
        _query = build_order_query(_query)
      end

      return _query
    end

    def build_arel_filter(filter_hash)
      filter_val = @params[filter_hash[:param_key]]
      filter_val = filter_hash[:preprocessor].call(filter_val) if filter_hash[:preprocessor]

      if filter_hash[:column].is_a?(Hash)
        arel_column_from_hash(filter_hash[:column]).method(filter_hash[:method]).call(filter_val)
      else
        @resource.arel_table[filter_hash[:column]].method(filter_hash[:method]).call(filter_val)
      end
    end

    def build_order_query(query)
      return query unless @params[:sort].present?
      sort_column = get_klass_var(:@sorters).find {|h| h[:param_key].to_s == @params[:sort].underscore}
      return query unless sort_column.present?

      if sort_column[:column].is_a?(Hash)
        query.order(arel_column_from_hash(sort_column[:column]))
      else
        query.order(sort_column[:column])
      end
    end

    private
    def get_klass_var(var)
      self.class.instance_variable_get(var)
    end

    def arel_column_from_hash(hash_param)
      raise ArgumentError, "Hash can only have one key." if hash_param.length > 1
      _resource = hash_param.keys.first.to_s.classify.constantize
      _resource.arel_table[hash_param.values.first]
    end

    def applied_filters
      _filters = []
      @params.each do |k,v|
        next unless v.present?
        next unless filter = get_klass_var(:@filters).find {|obj| obj[:param_key] == k}
        _filters.push filter
      end

      _filters
    end
  end
end