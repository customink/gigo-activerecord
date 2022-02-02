module GIGO
  module ActiveRecord
    module Base
      def gigo_column(*attrs)
        mod = begin
          if const_defined?(:GIGOColumns)
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
              begin
                GIGO.load(super)
              rescue NoMethodError, ActiveModel::MissingAttributeError
                nil
              end
            end
          CODE
        end
      end

      def gigo_columns(*excepts)
        cols = columns.select{ |c| c.type == :string || c.type == :text }.map{ |c| c.name.to_s } - excepts.map(&:to_s)
        gigo_column(*cols)
      end

      def after_initialize_gigoize_attributes
        after_initialize :gigoize_attributes
        define_method :gigoize_attributes do
          self.class.const_get(:GIGOColumns).instance_methods.each { |name| self.send(name) }
        end
        private :gigoize_attributes
      end

      def gigo_coder_for(klass)
        GigoCoder.new(klass)
      end

      class GigoCoder
        attr_reader :klass

        class SerializationTypeMismatch < StandardError
        end

        def initialize(klass)
          @klass = klass
          @default_internal = Encoding.default_internal
        end

        def load(yaml)
          return klass.new if yaml.nil?
          Encoding.default_internal = GIGO.encoding
          value = YAML.load(GIGO.load(yaml))
          unless value.is_a?(klass)
            raise SerializationTypeMismatch, "Attribute was supposed to be a #{klass.to_s}, but was a #{value.class}."
          end
          value
        ensure
          Encoding.default_internal = @default_internal
        end

        def dump(value)
          return klass.new.to_yaml if value.nil?
          unless value.is_a?(klass)
            raise SerializationTypeMismatch, "Attribute was supposed to be a #{klass.to_s}, but was a #{value.class}."
          end
          value.to_yaml
        end
      end
    end
  end
end

ActiveRecord::Base.extend GIGO::ActiveRecord::Base
