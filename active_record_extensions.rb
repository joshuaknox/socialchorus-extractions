module ActiveRecord
  module Calculations
    def multi_sum(*columns)
      sums_expression = columns.map {|column| "SUM(COALESCE(#{column},0))" }.join(' + ')
      select("#{sums_expression} AS result").first.result.to_i
    end

    def weighted_multi_sum(hash)
      sums_expression = hash.map {|column, weight| "SUM(COALESCE(#{column},0))*#{weight}"}.join(' + ')
      select("#{sums_expression} AS result").first.result.to_i
    end

    def named_multi_sums(hash, fun = lambda {|x| x })
      dummy = Hashie::Mash.new
      sums_expression = hash.map {|name, columns| columns.map {|column| "SUM(COALESCE(#{column},0))"}.join(' + ') + " as #{name}"}.join(', ')
      result = select("#{sums_expression}").first
      hash.map {|name, trash| dummy[name] = fun[result.send(name).to_i]}
      dummy
    end
  end

  module Batches
    def find_each_with_limit(options = {})
      find_in_batches_with_limit(options) do |records|
        records.each { |record| yield record }
      end
    end

    def find_in_batches_with_limit(options = {})
      relation = self

      if (finder_options = options.except(:start, :batch_size)).present?
        relation = apply_finder_options(finder_options)
      end

      start = options.delete(:start).to_i
      total_limit = options.delete(:limit) || @limit_value
      batch_size = [options.delete(:batch_size) || 1000, total_limit].compact.min

      relation = relation.limit(batch_size)
      records = relation.where(table[primary_key].gteq(start)).all
      total_records_found = records.size

      while records.any? && (total_limit.to_i == 0 || total_records_found <= total_limit)
        records_size = records.size
        primary_key_offset = records.last.id

        yield records

        break if records_size < batch_size

        if primary_key_offset
          records = relation.where(table[primary_key].gt(primary_key_offset)).to_a
          total_records_found += records.size
        else
          raise "Primary key not included in the custom select clause"
        end
      end
    end

  end

end
