require 'active_support/concern'
require 'active_support/core_ext/hash/deep_merge'

module ActiveresourceHeaders
  module CustomHeaders
    extend ActiveSupport::Concern

    module ClassMethods

      def custom_headers(&block)
        @custom_headers = block
      end

      def with_headers(headers={})
        @with_headers = headers
        self
      end

      def connection
        cn = super
        headers = @custom_headers ? @custom_headers.call : {}
        headers = headers.deep_merge((@with_headers || {}))
        cn.send(:default_header).update(headers)
        cn
      end
    end

  end
end
