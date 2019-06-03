#!/usr/bin/env ruby
require 'bunny'
require './src/server/program_executor.rb'
require './src/server/server_config.rb'


class RPCServer
  attr_accessor :configuration
  def initialize
    load_configuration
    if @configuration.json_content.empty?
      exit(1)
    end
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start
    @queue = channel.queue(@configuration.server_queue_name)
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
      stdout_str, error_str, status, file_path = executor.execute(payload,@configuration.ruby_path,@configuration.result_folder_path)
      result = "Output:\n#{stdout_str}\nErrors:\n#{error_str}\n\n"
      exchange.publish(
          result,
          routing_key: properties.reply_to,
          correlation_id: properties.correlation_id
      )
    end
  end

  def load_configuration
    @configuration = ServerConfigurationLoader.new
    @configuration.load_configuration("./serverConfig.json")
  end
end

begin
  server = RPCServer.new
  puts ' [x] Awaiting RPC requests'
  server.start()
  server.loop_forever
rescue Interrupt => _
  server.stop
end