Dir["lib/*.rb"].each {|file| require_relative file }

require 'rubygems'

$ROOT = File.dirname(__FILE__)