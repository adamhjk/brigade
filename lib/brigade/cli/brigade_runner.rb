#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2009 Adam Jacob 
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'mixlib/cli'
require 'brigade/cli'
require 'brigade/config'
require 'brigade/consumer'
require 'mq'

module Brigade 
  class CLI
    class BrigadeRunner
      include Mixlib::CLI

      option :queue_name,
        :short => "-q QUEUE",
        :long => "--queue QUEUE",
        :description => "Default queue name - should be unique",
        :default => "brigade-#{rand(10000)}" # Cheap hack

      option :topic,
        :short => "-p PATTERN",
        :long => "--pattern PATTERN",
        :description => "The route pattern to listen on (defaults to brigade.#)",
        :default => "brigade.#"

      options.merge!(Brigade::CLI.options)

      def run
        args = parse_options
        Brigade::Config.merge!(config)
        @amq = MQ.new(
          AMQP.connect({
            :host => Brigade::Config['amqp_host'],
            :port => Brigade::Config['amqp_port'],
            :user => Brigade::Config['amqp_user'],
            :pass => Brigade::Config['amqp_pass'],
            :vhost => Brigade::Config['amqp_vhost'],
            :timeout => Brigade::Config['amqp_connection_timeout'],
            :logging => Brigade::Config['amqp_logging']
          })
        )
        @amq.topic("brigade", { :durable => true, :nowait => false }).publish("I want a pony", :key => "brigade.pony")
      end
    end
  end
end



