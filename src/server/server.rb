#!/usr/bin/env ruby
require 'bunny'
require './src/server/programExecutor.rb'

class RPCServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    queue.subscribe do |_delivery_info, properties, payload|

      executor = ProgramExecutor.new
      stdout_str, error_str, status = executor.execute(payload)
      result = "Output:\n#{stdout_str}\nErrors:\n#{error_str}\n\n"
      exchange.publish(
          result,
          routing_key: properties.reply_to,
          correlation_id: properties.correlation_id
      )
    end
  end
end

begin
  server = RPCServer.new

  puts ' [x] Awaiting RPC requests'
  server.start('rpc_queue')
  server.loop_forever
rescue Interrupt => _
  server.stop
end