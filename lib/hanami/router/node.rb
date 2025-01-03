# frozen_string_literal: true

require "hanami/router/leaf"

module Hanami
  class Router
    # Trie node
    #
    # @api private
    # @since 2.0.0
    class Node
      # @api private
      # @since 2.0.0
      attr_reader :to

      # @api private
      # @since 2.0.0
      def initialize
        @variable = nil
        @fixed = nil
        @leaves = []
      end

      # @api private
      # @since 2.0.0
      def put(segment)
        if variable?(segment)
          @variable ||= self.class.new
        else
          @fixed ||= {}
          @fixed[segment] ||= self.class.new
        end
      end

      # @api private
      # @since 2.0.0
      def get(segment)
        @fixed&.fetch(segment, nil) || @variable
      end

      # @api private
      # @since 2.0.0
      def leaf!(route, to, constraints)
        @leaves << Leaf.new(route, to, constraints)
      end

      # @api private
      # @since 2.2.0
      def match(path)
        @leaves&.find { |leaf| leaf.match(path) }
      end

      private

      # @api private
      # @since 2.0.0
      def variable?(segment)
        Router::ROUTE_VARIABLE_MATCHER.match?(segment)
      end
    end
  end
end
