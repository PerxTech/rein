module Rein
  # This module contains methods for creating/dropping schemas.
  module Schema
    def create_schema(*args)
      reversible do |dir|
        dir.up { _create_schema(*args) }
        dir.down { _drop_schema(*args) }
      end
    end

    def drop_schema(*args)
      reversible do |dir|
        dir.up { _drop_schema(*args) }
        dir.down { _create_schema(*args) }
      end
    end

    private

    def _create_schema(name)
      execute("CREATE SCHEMA #{name}")
    end

    def _drop_schema(name)
      execute("DROP SCHEMA #{name}")
    end
  end
end
