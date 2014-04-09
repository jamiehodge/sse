Sequel.migration do
  up do
    create_notification_function
  end

  down do
    drop_notification_function
  end
end
