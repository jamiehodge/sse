require "forwardable"

module App
  module Controller
    class EventStream
      extend Forwardable

      attr_reader :io

      def initialize(io)
        @io = io
      end

      def_delegators :io, :close, :closed?

      def write(payload)
        io << "event: #{payload[:event]}\n"
        io << "data:  #{payload[:data].to_json}\n\n"
      rescue Errno::EPIPE
      end
    end
  end
end
