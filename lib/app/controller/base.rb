require "mustermann"
require "sinatra"
require "slim"

require_relative "../descendable"

module App
  module Controller
    class Base < Sinatra::Base
      extend Descendable

      register(Mustermann)
      set(:pattern, capture: { id: :digit })

      enable(:method_override, :logging)

      class << self

        def basename
          name.split("::").last.downcase
        end

        def root
          File.expand_path("../", __dir__)
        end

        def template
          Mustermann.new("/:basename(/:id)")
        end

        def views
          File.expand_path("template", root)
        end
      end

      def find_template(views, name, engine, &block)
        super(File.join(views, self.class.basename.to_s), name, engine, &block)
        super(File.join(views, "base"), name, engine, &block)
      end

      def hijack
        headers["rack.hijack"] = lambda do |io|
          Thread.new do
            begin
              yield io
            rescue Errno::ECONNRESET
            ensure
              io.close unless io.closed?
            end
          end
        end
      end

      def id
        params[:id]
      end

      def uri(obj, absolute = true, add_script_name = true)
        return super unless obj.respond_to?(:basename)

        basename = obj.basename
        id       = obj.id if obj.respond_to?(:id)
        path     = self.class.template.expand(basename: basename, id: id)

        super(path, absolute, false)
      end

      alias url uri
      alias to  uri

      alias respond_with slim
    end
  end
end
