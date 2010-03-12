#!/usr/bin/ruby

$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rubygems'
require 'brigade/cli/watcher'
require 'eventmachine'

EM.run { Brigade::CLI::Watcher.new.run }

