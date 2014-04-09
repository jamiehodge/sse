require "sequel"

class Sequel::Database

  def create_notification_trigger(table_name)
    create_trigger(table_name, :notify, :notify, each_row: true)
  end

  def drop_notification_trigger(table_name)
    drop_trigger(table_name, :notify)
  end

  def create_notification_function
    create_function(:notify, <<-SQL, language: :plpgsql, returns: :trigger, replace: true)
      BEGIN
        IF (TG_OP = 'DELETE') THEN
          PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || OLD.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
          RETURN OLD;
        ELSE
          PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || NEW.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
          RETURN NEW;
        END IF;
      END;
    SQL
  end

  def drop_notification_function
    drop_function(:notify)
  end
end
