require 'spec_helper'

RSpec.describe Rein::Constraint::Presence do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Presence
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_presence_constraint' do
    context 'given a table and attribute' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_isbn_presence CHECK ((\"isbn\" IS NOT NULL) AND (\"isbn\" !~ '^\\s*$'))))
        adapter.add_presence_constraint(:books, :isbn)
      end
    end

    context 'given a table and attribute and if option' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_isbn_presence CHECK (NOT (state = 'published') OR ((\"isbn\" IS NOT NULL) AND (\"isbn\" !~ '^\\s*$')))))
        adapter.add_presence_constraint(:books, :isbn, if: "state = 'published'")
      end
    end

    context 'given a name option' do
      it 'adds a constraint with that name' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_state_is_valid CHECK ((\"isbn\" IS NOT NULL) AND (\"isbn\" !~ '^\\s*$'))))
        adapter.add_presence_constraint(:books, :isbn, name: 'books_state_is_valid')
      end
    end
  end

  describe '#remove_presence_constraint' do
    it 'removes a constraint' do
      expect(subject).to receive(:execute).with(%(ALTER TABLE "books" DROP CONSTRAINT books_isbn_presence))
      subject.remove_presence_constraint(:books, :isbn)
    end
  end
end
