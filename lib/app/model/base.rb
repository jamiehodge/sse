require_relative "../db"

module App
  Base ||= Class.new(Sequel::Model) do

    def self.basename
      table_name.to_s
    end

    def basename
      self.class.basename
    end
  end
end
