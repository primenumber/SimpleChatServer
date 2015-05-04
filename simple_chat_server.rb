require 'em-websocket'
require 'json'
require_relative 'user'

$connections = []

def broadcast(name, message, tags)
# check
  return false if !name.instance_of?(String)
  return false if !message.instance_of?(String)
  return false if !tags.instance_of?(Array)
  tags.each {|tag| return false if !tag.instance_of?(String)}
# generate data
  json = JSON.generate({
    "type" => "broadcast",
    "name" => name,
    "message" => message,
    "tags" => tags
  })
# send
  $connections.each do |conn|
    conn.send(json)
  end
  return true
end
 
def load
  if File.exist?('userdata.dat') then
    file = File.open('userdata.dat')
    json = file.read
    file.close
    data = JSON.parse(json)
    data['users'].map {|user| puts user.to_s}
    $users = data['users'].map {|user| User.new(user)}
    puts 'userdata loaded'
  else
    puts 'userdata file not found'
  end
end

def save
  file = File.open('userdata.dat', 'w')
  file.write JSON.generate({"users" => $users.map {|user| user.to_h_private}})
  file.close
end

load()

EM::WebSocket.start(host: 'localhost', port: 14141) do |ws|
  ws.onopen do
    puts "new client"
    $connections << ws
  end

  ws.onmessage do |message|
    puts "received: " + message
    data = JSON.parse(message)
    case data['type']
    when "broadcast" then
      index = $users.index {|u| u.id == data['id']}
      if index != nil then
        broadcast($users[index].name, data['message'], data['tags'])
      end
    when "new_user" then
      if data['name'] != nil then
        user = add_user(data['name'])
        if user != nil then
          ws.send(JSON.generate({"type" => "self_user_data", "user" => user.to_h_private}))
        else
          ws.send(JSON.generate({"type" => "error", "message" => "The Username is already exist"}))
        end
      end
    when "get_user_data" then
      index = $users.index {|u| u.id == data['id']}
      if index != nil then
        ws.send(JSON.generate({"type" => "self_user_data", "user" => $users[index].to_h_private}))
      else
        ws.send(JSON.generate({"type" => "error", "message" => "No such user"}))
      end
    end
  end

  ws.onclose do
    $connections.delete(ws)
    puts "client closed"
  end
end
