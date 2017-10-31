require 'active_record'
# require 'active_record/version'
# require 'active_support/core_ext/module'

# begin
#   require 'rails/engine'
# end

module Yannitor
  module Broom
    attr_accessor :features

    def yannitor_is_cleaning(feats = {})
      self.features = feats
    end

    def to_one_hot target_column, type = 'text'
      sorted_value_array = self.pluck("distinct(#{target_column})")

      _table_name   = self.table_name
      values_select = %Q(SELECT value FROM (values ('#{ sorted_value_array.join("'), ('") }')) s(value))

      self.select(%Q(
        #{_table_name}.id,
        ARRAY_AGG(CASE WHEN sorted_value_table.value::#{type} = #{_table_name}.#{target_column}::#{type} THEN 1 ELSE 0 END) AS o#{target_column}
      )).joins(%Q(
        LEFT JOIN (#{values_select}) AS sorted_value_table ON 1=1
      )).group("#{_table_name}.id")
    end

    def vectorize
      _table_name   = self.table_name

      select('*, ' + features[:linear].map do |feature|
        min = all.minimum(feature)
        max = all.maximum(feature)
        "CAST((#{_table_name}.#{feature}::float - #{min}::float) / (#{max}::float - #{min}::float) AS float) as n#{feature}"
      end.join(', ')).all.map do |obj|

        obj.class.features[:linear].map do |feature|
          obj.send("n#{feature}").to_f
        end
      end
    end

    def nelect(feature)
      _table_name   = self.table_name

      min = all.minimum(feature)
      max = all.maximum(feature)
      
      self.select("*, (#{_table_name}.#{feature}::float - #{min}::float) / (#{max}::float - #{min}::float)::float as n#{feature}")
    end

    def normalize(feature)
      print "Normalizing #{feature}"
      min = all.minimum(feature)
      max = all.maximum(feature)
      data = all.nelect(feature).map do |e|
        e.send("n#{feature}".to_sym)
      end

      [data, min, max]
    end

    def to_file
      CSV.open("data.csv", "wb", {col_sep: ' '}) do |csv|
        all.vectorize.each { |v| csv << v }
      end

      nil
    end

  end
end

ActiveSupport.on_load(:active_record) do
  extend Yannitor::Broom
end
