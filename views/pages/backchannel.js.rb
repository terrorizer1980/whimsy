#
# Overall Agenda page: simple table with one row for each item in the index
#

class Backchannel < React
  def initialize
    @welcome = 'Loading messages'
  end

  # place a message input field in the buttons area
  def self.buttons()
    return [{button: Message}]
  end

  # render a list of messages
  def render
    _header do
      _h1 'Agenda Backchannel'
    end

    datefmt = proc do |timestamp|
      return Date.new(timestamp).
        toLocaleDateString({}, month: 'short', day: 'numeric', year: 'numeric')
    end

    if Chat.log.empty?
      _em @welcome
    else
      i = 0

      # group messages by date
      while i < Chat.log.length
        date = datefmt(Chat.log[i].timestamp)
        _h5.chatlog date unless i == 0 and date == datefmt(Date.new().valueOf())

        # group of messages that share the same (local) date
        _dl.chatlog do
          while i < Chat.log.length
            message = Chat.log[i]
            break if date != datefmt(message.timestamp)
            _dt message.user, key: "t#{message.timestamp}",
              title: Date.new(message.timestamp).toLocaleTimeString(),
              class: ('info' if message.type == :info)
            _dd message.text, key: "d#{message.timestamp}",
              class: ('info' if message.type == :info)
            i += 1
          end
        end
      end
    end
  end

  # on initial display, fetch backlog
  def componentDidMount()
    return if Chat.log.any? {|item| item.type == :chat}

    fetch "chat/#{Agenda.file[/\d[\d_]+/]}", :json do |messages|
      messages.each {|message| Chat.add message}
      @welcome = 'No messages found.'
      Main.refresh()
    end
  end

  # after update, scroll to the bottom of the page
  def componentDidUpdate()
    window.scrollTo(0, document.body.scrollHeight)
  end
end
