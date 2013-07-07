require "ruby-processing"

class ProcessArtist < Processing::App
	
	def setup
		background(0, 0, 0)
	end

	def draw
		# do stuff
	end

	def run_command(command)
		puts "Running Command #{command}"
	end

	def key_pressed
		warn "A key was pressed! #{key.inspect}"
		if @queue.nil?
			@queue = ""
		end
		if key != "\n"
			@queue += key
		else
			warn "Time to run the command: #{@queue}"
			run_command(@queue)
			@queue = ""
		end
	end

end

ProcessArtist.new(:width => 800, :height => 600, :title => "Process Artist", 
									:full_screen => false)