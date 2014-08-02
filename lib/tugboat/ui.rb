module Vagrant
  module UI
    # The basic UI interface provides output and
    class Basic
      # Colors for UI output
      RED    = "\033[31m"
      GREEN  = "\033[32m"
      YELLOW = "\033[33m"
      GREY   = "\033[37m"
      CLEAR  = "\033[0m"
      PREFIX = "    "

      def init(machine=false)
        @machine_readable = machine
      end

      # Outputs the message
      #
      # Possible output levels (lowest to highest) are:
      #   info:    info statements that aren't important. gray coloring,
      #            indented (   )
      #   output:  standard output (things are happening), no coloring,
      #            basic prefix (==>)
      #   success: successful actions, greeen, indented (   )
      #   warn:    warnings, yellow, indented (   )
      #   fail:    failures/danger, red, indented (   )
      def say(message, level)
        # If we've set machine-readable, don't color and
        # merge the message into a line with commas instead of
        # new lines.
        if @machine_readable
          message.gsub!("\n", ",") # Newlines to commas
          message.gsub!(/\s/, ' ') # Make spaces/indents single
          puts "#{Time.now.utc.to_i},#{message}"
          return
        end

        case level
        when :info
          puts "#{PREFIX} #{GREY}#{message}#{CLEAR}"
        when :output
          puts "===> #{message}#{CLEAR}"
        when :ask
          puts "#{message}#{CLEAR}: "
        when :success
          puts "#{PREFIX} #{GREEN}#{message}#{CLEAR}"
        when :warn
          puts "#{PREFIX} #{YELLOW}#{message}#{CLEAR}"
        when :fail
          puts "#{PREFIX} #{RED}#{message}#{CLEAR}"
        end
      end
    end

    # Asks a message of the user
    def ask(message)
      if @machine_readable
        raise Exception("No input in machine-readable")
      end

      # Output the message first
      say(message, :ask)

      input = nil
      if opts[:echo]
        input = $stdin.gets
      else
        input = $stdin.noecho(&:gets)
        say(:info, "\n", opts)
      end
      (input || "").chomp
    end

  end
end