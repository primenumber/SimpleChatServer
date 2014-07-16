$users = []

class User
  attr_reader :name, :id
  def initialize(hash)
    @name = hash['name']
    @id = hash['id']
  end

  def to_h
    {
      "name" => @name
    }
  end

  def to_h_private
    {
      "id" => @id,
      "name" => @name
    }
  end
end

def make_userid(username)
  id_str = ""
  while id_str == "" || $users.index {|u| u.id == id_str } != nil do
    id_str = SecureRandom.hex(64)
  end
  return id_str
end

def add_user(username)
  if $users.index {|u| u.name == username} != nil then
    return nil
  else
    userid = make_userid(username)
    new_user = User.new({"name" => username, "id" => userid})
    $users << new_user
    save
    return new_user
  end
end
