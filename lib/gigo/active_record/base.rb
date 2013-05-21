module GIGO
  module ActiveRecord
    module Base
      
      def gigo_serialized_attribute(*attrs)
        attrs.each do |attr|
          yaml_column = self.serialized_attributes[attr.to_s]
          next unless yaml_column
          yaml_column.class_eval do
            def load_with_gigo(yaml)
              existing_encoding = Encoding.default_internal
              Encoding.default_internal = GIGO.encoding
              yaml = GIGO.load(yaml)
              load_without_gigo(yaml)
            ensure
              Encoding.default_internal = existing_encoding
            end
            alias_method_chain :load, :gigo
          end
        end
      end

      def gigo_column(*attrs)
        mod = begin
          if defined?(GIGOColumns)
            const_get(:GIGOColumns)
          else
            m = const_set(:GIGOColumns, Module.new)
            include m
            m
          end
        end
        attrs.each do |attr|
          mod.module_eval <<-CODE, __FILE__, __LINE__
            def #{attr}
              GIGO.load(super)
            end
          CODE
        end
      end

    end
  end
end

ActiveRecord::Base.extend GIGO::ActiveRecord::Base
