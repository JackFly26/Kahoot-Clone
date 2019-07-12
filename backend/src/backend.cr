require "kemal"

module Backend
  VERSION = "0.1.0"

  public_folder ARGV[0]

  ws "/" do |socket|
    socket.on_message do |message|
      case message.to_i { -1 }
      when Int32
        socket.close message
      end
    end
  end

  Kemal.run
end
