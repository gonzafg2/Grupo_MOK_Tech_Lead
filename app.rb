require 'sinatra'
require_relative 'app/index.rb'

configure do
  generateReport
  puts "Initializing app..."
end

get '/' do
  send_file 'app/views/index.html'
end
