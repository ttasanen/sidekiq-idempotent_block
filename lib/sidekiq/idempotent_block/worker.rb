# frozen_string_literal: true

module Sidekiq
  module IdempotentBlock
    module Worker

      def idempotent_block(name, opts = {}, &block)
        store_result = opts.fetch(:store_result, false)
        executed_at, result = idempotent_block_already_executed?(name)

        if executed_at
          Sidekiq.logger.warn "[IdempotentBlock] Skipped block #{self.class.name}##{name} Executed at #{executed_at.utc.iso8601(3)}"
          return result
        end

        result = block.call
        idempotent_block_success(name, (store_result ? result : nil))

        result
      end

      def idempotent_block_already_executed?(block_name)
        value = Sidekiq.redis do |redis|
          redis.get(idempotent_block_key_for(block_name))
        end

        return false unless value

        begin
          Marshal.load(value)
        rescue TypeError, ArgumentError
          false
        end
      end

      def idempotent_block_success(block_name, result)
        value = ::Marshal.dump([::Time.now, result])

        Sidekiq.redis do |redis|
          redis.set(idempotent_block_key_for(block_name), value)
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
