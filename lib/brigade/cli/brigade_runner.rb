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
require 'donkey'

module Brigade 
  class CLI
    class BrigadeRunner
      include Mixlib::CLI

      option :node_name,
        :short => "-N NODE_NAME",
        :long => "--node-name NODE_NAME",
        :description => "The node name for this client",
        :proc => nil
      
      options.merge!(Brigade::CLI.options)

      def run
        args = parse_options
        Brigade::Config.merge!(config)
        
        sender = Donkey.start("brigade-runner") do
          def on_cast
            puts message.data
          end
        end
        sender.bcall("brigade-client", { :type => "chef-client" } )
      end
    end
  end
end

