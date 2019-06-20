require 'active_record/connection_adapters/sqlite3_adapter'

module ActiveRecord
  module ConnectionAdapters
    class SQLite3Adapter < AbstractAdapter
      private
      def _type_cast(value)
        case value
        when BigDecimal
          value.to_f
        when String
          if value.encoding == Encoding::ASCII_8BIT
            value
          else
            super
          end
        else
          super
        end
      end
    end
  end
end