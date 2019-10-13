require "kemal"

module Backend
  VERSION = "0.1.0"

  public_folder ARGV[0]

  ws "/" do |socket|
    socket.on_message do |message|
      case message.to_i { -1 }
      when 0
        puts "test"
        socket.send "1"
      else
        socket.send "0"
      end
      socket.close
    end
  end

  Kemal.run
end
