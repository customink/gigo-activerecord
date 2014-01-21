module GIGO
  module ActiveRecord
    module Base

      module Shared

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

      end

      module ThreeOhOnly

        include Shared

        def gigo_serialized_attribute(*attrs)
          # ActiveRecord 3.0 has no proper hooks. So we fix all YAML object laoding for this class.
          include InstanceMethods
        end

        module InstanceMethods

          private

          def object_from_yaml(string)
            return string unless string.is_a?(String) && string =~ /^---/
            begin
              existing_encoding = Encoding.default_internal
              Encoding.default_internal = GIGO.encoding
              s = GIGO.load(string)
              YAML::load(s) rescue s
            ensure
              Encoding.default_internal = existing_encoding
            end
          end

        end

      end

      module ThreeOneAndUp

        include Shared

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

      end

    end
  end
end

if ActiveRecord::VERSION::STRING < '3.1'
  ActiveRecord::Base.extend GIGO::ActiveRecord::Base::ThreeOhOnly
else
  ActiveRecord::Base.extend GIGO::ActiveRecord::Base::ThreeOneAndUp
end

