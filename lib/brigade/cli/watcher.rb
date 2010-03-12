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
require 'brigade/formatter'
require 'mq'
require 'donkey'
require 'chef'
require 'chef/client'

module Brigade 
  class CLI
    class Watcher
      include Mixlib::CLI

      option :queue_name,
        :short => "-q QUEUE",
        :long => "--queue QUEUE",
        :description => "Default queue name - should be unique",
        :default => "brigade-watcher-#{rand(10000)}" # Cheap hack

      option :topic,
        :short => "-p PATTERN",
        :long => "--pattern PATTERN",
        :description => "The route pattern to listen on (defaults to brigade.#)",
        :default => "brigade.#"

      options.merge!(Brigade::CLI.options)

      def run
        args = parse_options
        Brigade::Config.merge!(config)

        Chef::Config.from_file("/etc/chef/client.rb")

        Donkey.start("brigade-client") do
          def on_call
            run_output = StringIO.new
            Chef::Log.logger = Logger.new(run_output)
            Chef::Log.logger.formatter = Brigade::Formatter.new
            Chef::Log.level = :info
            chef_client = Chef::Client.new
            chef_client.node_name = Chef::Config[:node_name] 
            chef_client.json_attribs = @chef_client_json
            chef_client.determine_node_name
            Chef::Log.logger.formatter.client_name = chef_client.node_name
            chef_client.run
            output = run_output.string
            Chef::Log.error(output)
            donkey.cast "sender", output 
            Chef::Log.init(STDOUT)
          end
        end
      end
    end
  end
end


