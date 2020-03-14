# Ruby REST API and SCM event Webhook process
require 'sinatra'
require 'json'
require 'pp'

# Functionalities of the code:
# REST API listens on localhost:port/payload
# We will be exposing the localhost to internet using 'ngrok' executable. ./ngrok http 4567
# So ngrok provides an URL, something like http://something123.io and it exposing localhost:4567
# REST API also gets the parameters in URL query strings
# SCM webhook needs to be configured as http://something123.io/payload?params={some_project_id}
post '/payload' do
  puts '---------------------------------------------------'
  req_head =  JSON.parse(request.env.to_json)
  #puts "Header full : #{req_head.inspect}"
  req_head_uri =  JSON.parse(request.env['REQUEST_URI'].to_json)
  puts "Header URI : #{req_head_uri.inspect}"
  req_head_param = JSON.parse(request.env['rack.request.query_hash'].to_json)
  puts "Req Header Params : #{req_head_param.inspect}"

  param_str = req_head_param['params']
  puts "Param string: #{param_str}"
  proj_id = param_str.partition('').first
  puts "Projectid string: #{project_id}"

  push = JSON.parse(request.body.read)
  # puts "I got some Request Body JSON: #{push.inspect}"
  if push.inspect.include? 'pullrequestreview'
    puts "This is PRR (Pull Request Review) event "
    rand_val = rand(1000)
    file_name = "pull_req_review_payload#{rand_val.to_s}.json"
    json_dump_file = File.open(file_name, "w")
    json_dump_file.puts JSON.pretty_generate(push)
    json_dump_file.close
  else
    puts "This is (PR) Pull Request event "
    rand_val = rand(1000)
    file_name = "pull_req_payload#{rand_val.to_s}.json"
    json_dump_file = File.open(file_name, "w")
    json_dump_file.puts JSON.pretty_generate(push)
    json_dump_file.close
  end
  puts '---------------------------------------------------'

  json_val = JSON.parse(File.read(json_dump_file))

  if json_val.include? 'pull_request'
    if json_val.include? 'review'
      review_state = json_val['review']['state']
      reviewer_id = json_val['review']['user']['login']
    else
      puts "Review tag not found"
    end
    developer_id = json_val['pull_request']['user']['login']
    source_branch = json_val['pull_request']['head']['ref']
    dest_branch = json_val['pull_request']['base']['ref']
    repo_name = json_val['pull_request']['head']['repo']['name']
    repo_url = json_val['pull_request']['head']['repo']['html_url']
    if repo_url.include? 'github'
      repo_tool = 'GitHub'
      puts "SCM_Tool used: #{repo_tool}"
    else
      puts 'It should be other SCM tools'
    end
    timestamp = json_val['pull_request']['updated_at']
  else
    puts 'Pull Request Tag NOT Found'
  end
  puts '---------------------------------------------------'

  json_data = "{
\"SCM_Values\": {
  \"ProjectId\": \"#{proj_id}\",
  \"Repo_Name\": \"#{repo_name}\",
  \"Repo_Url\": \"#{repo_url}\",
  \"Source_Branch_Name\" : \"#{source_branch}\",
  \"Destination_Branch_Name\" : \"#{dest_branch}\",
  \"SCM_tool\": \"#{repo_tool}\",
  \"Reviewer_UserID\": \"#{reviewer_id}\",
  \"Developer_UserID\": \"#{developer_id}\",
  \"Review_Status\": \"#{review_state}\"
  }
}"

  puts "Metrics JSON: "
  pp JSON.parse(json_data.to_json)
  file_name = "metrics_json_#{app_id}_#{rand_val.to_s}.json"
  json_out_file = File.open(file_name, "w")
  json_out_file.puts metrics_json
  json_out_file.close

end
