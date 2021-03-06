require 'active_support/concern'

module ActiveAdmin

  # Adds a class method to a class to create settings with default values.
  #
  # Example:
  #
  #   class Configuration
  #     include ActiveAdmin::Settings
  #
  #     setting :site_title, "Default Site Title"
  #
  #     def initialize
  #       # You must call this method to initialize the defaults
  #       initialize_defaults!
  #     end
  #
  module Settings
    extend ActiveSupport::Concern

    module InstanceMethods

      def default_settings
        self.class.default_settings
      end

    end

    module ClassMethods

      def setting(name, default)
        default_settings[name] = default
        attr_accessor(name)

        # Create an accessor that grabs from the defaults
        # if @name has not been set yet
        class_eval <<-EOC, __FILE__, __LINE__
          def #{name}
            if instance_variable_defined? :@#{name}
              @#{name}
            else
              default_settings[:#{name}]
            end
          end
        EOC
      end

      def default_settings
        @default_settings ||= {}
      end

    end
  end
end
