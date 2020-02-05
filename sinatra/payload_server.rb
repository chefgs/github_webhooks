require 'sinatra'
require 'json'

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some Request Body JSON: #{push.inspect}"
  
  json_dump_file = File.open("req_payload.json", "w")
  json_dump_file.puts JSON.pretty_generate(push)
  json_dump_file.close
end
