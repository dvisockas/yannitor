# frozen_string_literal: true

require 'active_record'

module Yannitor
  module Broom
    attr_accessor :yannitor_features

    def yannitor_is_cleaning(features = {})
      self.yannitor_features = features
    end

    def to_one_hot(target_column, type = 'text')
      self.select(%(
        #{table_name}.id,
        ARRAY_AGG(CASE
          WHEN sorted_value_table.value::#{type} = #{table_name}.#{target_column}::#{type}
          THEN 1
          ELSE 0
          END
        ) AS o#{target_column}
      )).joins(%(
        LEFT JOIN (#{values_for_select(target_column)}) AS sorted_value_table ON 1=1
      )).group("#{table_name}.id")
    end

    def values_for_select(target_column)
      sorted_values = pluck("distinct(#{target_column})").join("'), ('")
      "SELECT value FROM (values ('#{sorted_values}')) s(value)"
    end

    def vectorize
      select('*, ' + linear_feature_select).build_linear_features
    end

    def build_linear_features
      all.map do |obj|
        obj.class.yannitor_features[:linear].map do |feature|
          obj.send("n#{feature}").to_f
        end
      end
    end

    def linear_feature_select
      yannitor_features[:linear].map do |feature|
        "CAST(#{min_max(feature)} AS float) as n#{feature}"
      end.join(', ')
    end

    def min_val(feature)
      min = all.minimum(feature)
      max = all.maximum(feature)

      "(#{table_name}.#{feature}::float - #{min}::float) / (#{max}::float - #{min}::float)"
    end

    def nelect(feature)
      select("*, #{min_max(feature)}::float as n#{feature}")
    end

    def normalize(feature)
      min = all.minimum(feature)
      max = all.maximum(feature)
      data = all.nelect(feature).map do |e|
        e.send("n#{feature}".to_sym)
      end

      [data, min, max]
    end

    def to_file(file_name = 'data.csv', separator = ' ')
      CSV.open(file_name, 'wb', col_sep: separator) do |csv|
        all.vectorize.each { |v| csv << v }
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend Yannitor::Broom
end
