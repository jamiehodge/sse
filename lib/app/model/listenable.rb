require "json"

module App
  module Model
    module Listenable

      def listen(io)
        check = proc { break if io.closed? }
        timeout = ENV["DATABASE_LISTEN_TIMEOUT"].to_f

        db.listen(table_name, loop: check, timeout: timeout) do |channel, pid, payload|
          check.call

          data   = JSON.parse(payload)
          record = self[data["id"]]
          result = { event: data["event"], data: record.values }

          yield result
        end
      rescue Sequel::PoolTimeout
      end

      module InstanceMethods

        def listen(io)
          self.class.listen(io) do |payload|
            yield payload if payload[:data][:id] == id
          end
        end
      end

      def self.extended(receiver)
        super
        receiver.send(:include, InstanceMethods)
      end
    end
  end
end
