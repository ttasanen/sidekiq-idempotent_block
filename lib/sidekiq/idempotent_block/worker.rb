# frozen_string_literal: true

module Sidekiq
  module IdempotentBlock
    module Worker

      def idempotent_block(name, &block)
        executed_at = idempotent_block_already_executed?(name)

        if executed_at
          Sidekiq.logger.info "[IdempotentBlock] Skipped block #{self.class.name}##{name} Executed at #{executed_at}"
          return
        end

        yield
        idempotent_block_success(name)
      end

      def idempotent_block_already_executed?(block_name)
        Sidekiq.redis do |redis|
          redis.get(idempotent_block_key_for(block_name))
        end
      end

      def idempotent_block_success(block_name)
        Sidekiq.redis do |redis|
          redis.set(idempotent_block_key_for(block_name), ::Time.now.utc.iso8601(3))
        end
      end

      def clear_idempotent_block_keys
        Sidekiq.redis do |redis|
          keys = redis.keys(idempotent_block_key_for('*'))
          redis.del(keys)
        end
      end

      def idempotent_block_key_for(block_name)
        "idempotent_block:#{jid}:#{block_name}"
      end
    end
  end
end
