module App
  module Descendable

    def inherited(subclass)
      children << subclass
      super
    end

    def children
      @children ||= []
    end

    def [](basename)
      children.detect {|child| child.basename == basename }
    end
  end
end
