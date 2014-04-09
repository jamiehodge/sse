require_relative "base"
require_relative "event_streamable"

module App
  module Controller
    class Jobs < Base
      extend EventStreamable

      get("/events", provides: :event_stream) do
        content_type :event_stream
        event_stream(jobs)
      end

      get("/:id/events", provides: :event_stream) do
        content_type :event_stream
        event_stream(job)
      end

      get("/") do
        respond_with(:list)
      end

      before("/:id") do
        not_found unless job
      end

      get("/:id") do
        respond_with(:read)
      end

      def self.model
        Model::Job
      end

      def job
        @job ||= id ? jobs[id] : model.new(params)
      end

      def jobs
        self.class.model
      end
    end
  end
end
