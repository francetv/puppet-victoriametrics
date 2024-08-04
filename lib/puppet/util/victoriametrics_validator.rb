# frozen_string_literal: true

require 'socket'
require 'timeout'
require 'ipaddr'
require 'uri'

module Puppet
  module Util
    class VictoriametricsValidator
      attr_reader :victoriametrics_server, :victoriametrics_port

      def initialize(victoriametrics_resource_name, victoriametrics_server, victoriametrics_port)
        # NOTE: (spredzy) : By relying on the uri module
        # we rely on its well tested interface to parse
        # both IPv4 and IPv6 based URL with a port specified.
        # Unfortunately URI needs a scheme, hence the http
        # string here to make the string URI compliant.
        uri = URI("http://#{victoriametrics_resource_name}")
        @victoriametrics_server = IPAddr.new(uri.host).to_s
        @victoriametrics_port = uri.port
      rescue StandardError
        @victoriametrics_server = victoriametrics_server.to_s
        @victoriametrics_port   = victoriametrics_port
      end

      # Utility method; attempts to make an https connection to the victoriametrics server.
      # This is abstracted out into a method so that it can be called multiple times
      # for retry attempts.
      #
      # @return true if the connection is successful, false otherwise.
      def attempt_connection
        Timeout.timeout(Puppet[:http_connect_timeout]) do
          TCPSocket.new(@victoriametrics_server, @victoriametrics_port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
          Puppet.debug "Unable to connect to victoriametrics server (#{@victoriametrics_server}:#{@victoriametrics_port}): #{e.message}"
          false
        end
      rescue Timeout::Error
        false
      end
    end
  end
end
