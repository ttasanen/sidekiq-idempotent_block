require "spec_helper"

describe Sidekiq::IdempotentBlock::Worker do

  before do
    @worker = Class.new do
      include Sidekiq::Worker
      include Sidekiq::IdempotentBlock::Worker
    end
  end

  describe '#idempotent_block' do
  end

  describe '#idempotent_block_already_executed?' do
  end

  describe '#idempotent_block_success' do
  end

  describe '#clear_idempotent_block_keys' do
  end

  describe '#idempotent_block_key_for' do
    expect(@worker.idempotent_block_key_for('foo')).to eq('')
  end
end
