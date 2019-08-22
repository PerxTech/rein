$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rein'
require 'support/migration'

MIGRATIONS_PATH = [File.expand_path('migrations', __dir__)].freeze

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a
    # real object. This is generally recommended, and will default to `true` in
    # RSpec 4.
    mocks.verify_partial_doubles = false
  end

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'rein_test')
    ActiveRecord::Base.connection.execute('DROP VIEW IF EXISTS books_per_author')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS schema_migrations')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS books')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS authors')
    ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS book_owners')
    if ActiveRecord.version.release >= Gem::Version.new('6.0.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH, ActiveRecord::SchemaMigration).migrate
    elsif ActiveRecord.version.release >= Gem::Version.new('5.2.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH).migrate
    else
      ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
    end
  end
end
