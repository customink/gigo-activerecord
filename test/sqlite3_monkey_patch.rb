=begin
This monkey patch is necessary because the SQLite3Adapter is smart enough to encode strings
that come in with Encoding::ASCII-8BIT to Encoding::UTF-8 but others aren't.
So to mimic the worst case, for example using a bad oracle adapter, we monkey patch the
SQLite3Adapter to just return the string instead of trying to encode it using utf8.
=end
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