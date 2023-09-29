require 'sinatra'
require_relative 'app/index.rb'

configure do
  generateReport
  puts "Initializing app..."
end

set :public_folder, 'app/public'

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end
