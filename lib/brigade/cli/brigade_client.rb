#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2010 Adam Jacob 
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
require 'brigade/formatter'
require 'donkey'
require 'chef'
require 'chef/client'

module Brigade 
  class CLI
    class Client 
      include Mixlib::CLI

      option :node_name,
        :short => "-N NODE_NAME",
        :long => "--node-name NODE_NAME",
        :description => "The node name for this client",
        :proc => nil

      option :splay,
        :short => "-s SECONDS",
        :long => "--splay SECONDS",
        :description => "The splay time for running at intervals, in seconds",
        :proc => lambda { |s| s.to_i }

      options.merge!(Brigade::CLI.options)

      def run
        args = parse_options
        Brigade::Config.merge!(config)

        Chef::Config.from_file("/etc/chef/client.rb")
        Chef::Config.node_name = config[:node_name] if config.has_key?(:node_name)

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
            puts message.data.inspect
            case message.data[:type]
            when "chef-client"
              chef_client.run
            when "chef-solo"
              chef_client.run_solo
            end
            output = run_output.string
            Chef::Log.info(output)
            donkey.cast "brigade-runner", output 
            Chef::Log.init(STDOUT)
          end
        end

        def on_error(error)
          Chef::Log.error(error)
          donkey.cast "brigade-runner", error 
        end
      end

    end
  end
end


