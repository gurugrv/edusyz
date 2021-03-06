module Searchkick
  module Model

    def searchkick(options = {})
      raise "Only call searchkick once per model" if respond_to?(:searchkick_index)

      class_eval do
        cattr_reader :searchkick_options, :searchkick_env, :searchkick_klass

        class_variable_set :@@searchkick_options, options.dup
        class_variable_set :@@searchkick_env, ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"
        class_variable_set :@@searchkick_klass, self
        class_variable_set :@@searchkick_callbacks, options[:callbacks] != false
        class_variable_set :@@searchkick_index, options[:index_name] || [options[:index_prefix], model_name.plural, searchkick_env].compact.join("_")

        def self.searchkick_index
          index = class_variable_get :@@searchkick_index
          index = index.call if index.respond_to? :call
          Searchkick::Index.new(index)
        end

        extend Searchkick::Search
        extend Searchkick::Reindex
        include Searchkick::Similar

        if respond_to?(:after_commit)
          after_commit :reindex, :if => lambda{|obj| obj.class.search_callbacks? }
        else
          after_save :reindex, :if => lambda{|obj| obj.class.search_callbacks? }
          after_destroy :reindex, :if => lambda{|obj| obj.class.search_callbacks? }
        end

        def self.enable_search_callbacks
          class_variable_set :@@searchkick_callbacks, true
        end

        def self.disable_search_callbacks
          class_variable_set :@@searchkick_callbacks, false
        end

        def self.search_callbacks?
          class_variable_get(:@@searchkick_callbacks) && Searchkick.callbacks?
        end

        def should_index?
          true
        end

        def reindex
          index = self.class.searchkick_index
          if destroyed? or !should_index?
            begin
              index.remove self
            rescue Elasticsearch::Transport::Transport::Errors::NotFound
              # do nothing
            end
          else
            index.store self
          end
        end

        def search_data
          attributes
        end

      end
    end

  end
end
