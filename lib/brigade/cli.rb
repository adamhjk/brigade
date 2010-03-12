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

module Brigade 
  class CLI
    include Mixlib::CLI
    
    option :log_level,
      :short => "-l LEVEL",
      :long  => "--log-level LEVEL",
      :description => "The log threshold (:debug, :info, :warn, :error, :fatal)",
      :proc => Proc.new { |l| Brigade::Log.level = l.to_sym }
      
    option :log_location,
      :long => "--log-location LOCATION",
      :description => "The location of the log file"
              
    option :amqp_host,
      :long => "--amqp-host HOST",
      :description => "The AMQP host"
      
    option :amqp_port,
      :long => "--amqp-port PORT",
      :description => "The AMQP port"
      
    option :amqp_user,
      :long => "--amqp-user USER",
      :description => "The AMQP user"
    
    option :amqp_pass,
      :long => "--amqp-pass PASS",
      :description => "The AMQP Password"
    
    option :amqp_vhost, 
      :long => "--amqp-vhost Vhost",
      :description => "The AMQP Vhost"
      
    option :amqp_connection_timeout,
      :long => "--amqp-timeout TIMEOUT",
      :description => "The AMQP connection timeout"
    
    option :amqp_logging,
      :long => "--amqp-logging",
      :boolean => true,
      :description => "Enable verbose AMQP debugging"

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0
  end
end
