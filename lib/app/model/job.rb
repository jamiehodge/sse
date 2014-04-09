require_relative "base"
require_relative "listenable"

module App
  module Model
    class Job < Base
      extend Listenable
    end
  end
end
