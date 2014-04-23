require 'json'
require 'sinatra'

get '/' do
  'Hello world!'
end

def fetch_users
  open('/etc/passwd') do |file|
    file.reject do |line|
      line.start_with? '#'
    end.map do |line|
      username, _, uid, gid, description, home, shell = line.split(':')
      {
        'username' => username,
        'uid' => uid,
        'gid' => gid,
        'description' => description,
        'home' => home,
        'shell' => shell,
      }
    end
  end
end

get '/passwd.json' do
  users = fetch_users
  json = JSON.generate(users)

  [200, {'Content-Type' => 'application/json'}, json]
end
