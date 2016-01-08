require 'active_support/concern'
require 'active_support/core_ext/hash/deep_merge'

module ActiveresourceHeaders
  ##
  # When included to #ActiveResource::Base model,
  # adds mthods to set additional headers for http
  # requests.
  module CustomHeaders
    extend ActiveSupport::Concern

    module ClassMethods

      # Sets block to execute each time. Block must
      # respond to #call and return #Hash each time.
      def custom_headers(&block)
        @custom_headers = block
      end

      # Saves headers #Hash for use in <i>current</i> request.
      def with_headers(headers={})
        @with_headers = headers
        self
      end

      # This kind of ActiveResource::Base.connection gets connection
      # by <tt>super</tt> and restores it's default header, then it
      # sets all the custom headers and clears @with_headers.
      #
      # Returns #ActiveResource::Connection
      def connection(*args)
        @custom_connection = super
        toggle_default_header
        set_headers
        @with_headers = nil
        @custom_connection
      end

    private
      # Saves connection default header for first time, and restores it
      # in connection every next time.
      def toggle_default_header
        if @last_default_header
          @custom_connection.send(:default_header).clear
          @custom_connection.send(:default_header).update(@last_default_header)
        else
          @last_default_header = @custom_connection.send(:default_header)
        end
      end

      # Sets all the custom headers, defined by #custom_headers and #with_headers
      def set_headers
        headers = @custom_headers ? @custom_headers.call : {}
        headers = headers.deep_merge((@with_headers || {}))
        @custom_connection.send(:default_header).update(headers)
      end
    end
  end
end
