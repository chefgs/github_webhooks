require 'json'
require 'pp'

json_file = ARGV[0]
json_val = JSON.load(File.read(json_file))

# puts "Push Request Block: Ref tag: #{json_val['ref']}"
puts "Pull Request Block: Brach Ref: #{json_val['pull_request']['head']['ref']}"
# puts "Pull Request Block:: #{json_val['pull_request']}"
puts "Pull Request Block: Html_url: #{json_val['pull_request']['head']['repo']['html_url']}"
html_url = json_val['pull_request']['head']['repo']['html_url']
if html_url.include? "github"
  repo_tool = 'GitHub' 
  puts "SCM_Tool used: #{repo_tool}"
else
  puts 'It should be AzureDevOps or TFS'
end
