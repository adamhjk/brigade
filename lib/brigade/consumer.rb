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

require 'brigade/config'
require 'brigade/log'
require 'mq'

module Brigade 
  class Consumer
    
    attr_accessor :mq
    
    def initialize
      @mq = MQ.new(
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
      Brigade::Log.debug("Initializing Brigade Consumer")
    end
    
    def subscribe(queue_name, route_pattern, options={}, &block)
      # These are the AMQP gem defaults
      options[:passive]     ||= false
      options[:durable]     ||= false
      options[:exclusive]   ||= false
      options[:auto_delete] ||= false
      options[:nowait]      ||= true
      
      mq.queue(queue_name, options).bind(
        mq.topic('brigade'), 
        { :key => route_pattern }
      ).subscribe do |info, data|
        block.call(info, data)
      end
    end
  end
end


