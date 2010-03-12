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

require 'mixlib/config'

module Brigade
  class Config
    extend Mixlib::Config

    log_level :info
    log_location STDOUT
    amqp_host '127.0.0.1'
    amqp_port '5672'
    amqp_user 'guest'
    amqp_pass 'guest'
    amqp_vhost '/'
    amqp_connection_timeout nil
    amqp_logging false
    
  end
end
