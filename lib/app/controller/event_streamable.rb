require_relative "event_stream"

Thread.abort_on_exception = true

module App
  module Controller
    module EventStreamable
      module InstanceMethods

        def event_stream(obj)
          hijack do |io|
            es = EventStream.new(io)

            obj.listen(es) do |payload|
              es.write(payload)
            end
          end
        end
      end

      def self.extended(receiver)
        super
        receiver.mime_type(:event_stream, "text/event-stream")
        receiver.send(:include, InstanceMethods)
      end
    end
  end
end
