require "spec_helper"

describe Sidekiq::IdempotentBlock do
  it "has a version number" do
    expect(Sidekiq::IdempotentBlock::VERSION).not_to be nil
  end
end
