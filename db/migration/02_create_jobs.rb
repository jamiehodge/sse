Sequel.migration do
  up do
    create_table(:jobs) do
      primary_key(:id)
      float(:progress, default: 0)
    end

    create_notification_trigger(:jobs)
  end

  down do
    drop_notification_trigger(:jobs)
  end
end
