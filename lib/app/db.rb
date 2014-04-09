require "sequel"

module App
  DB ||= Sequel.connect(ENV["DATABASE_URL"], max_connections: ENV["DATABASE_MAX_CONNECTIONS"])
end
