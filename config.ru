require "./lib/app"

map("/") do
  run proc {|env| [303, { "Location" => "/jobs" }, []]}
end

App::Controller::Base.children.each do |child|
  map("/#{child.basename}") { run child }
end
