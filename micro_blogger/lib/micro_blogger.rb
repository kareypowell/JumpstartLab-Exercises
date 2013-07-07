require "jumpstart_auth"
require "bitly"
require "klout"


class MicroBlogger
	attr_reader :client


	def initialize
		puts "Initializing..."
		Bitly.use_api_version_3
		Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
		@client = JumpstartAuth.twitter
		@bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
	end
	

	def tweet(message)
		message.length <= 140 ? @client.update(message) : (puts "That tweet is too long! Haven't you ever used Twitter before?")
	end


	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message

		screen_names = @client.followers.collect { |follower| follower.screen_name }
		
		if screen_names.include? target
			direct_message = "d #{target} #{message}"
			tweet(direct_message)
		else
			puts "You can only direct message people who follow you."
		end
	end


	def followers_list
		screen_names = []
		users = @client.followers
		users.each { |follower| screen_names << follower["screen_name"] }
		screen_names
	end


	def spam_my_followers(message)
		followers_list.each { |follower| dm(follower, message) }
	end


	def everyones_last_tweet
		friends = @client.friends.sort_by
		sorted_friends = friends.sort_by { |friend| friend.screen_name.downcase }

		sorted_friends.each do |friend|
			timestamp = friend.status.created_at.strftime("%A, %b %d")
      puts "\nOn #{timestamp} #{friend.user_name} said..."
      puts "#{friend.status.text}\n"
		end
	end


	def shorten(original_url)
		puts "Shortening this URL: #{original_url}"
		return @bitly.shorten(original_url).short_url
	end


	def klout_score
		friends = @client.friends.collect { |friend| friend.screen_name }

		friends.each do |friend|
			begin
				identity = Klout::Identity.find_by_screen_name(friend)
				user = Klout::User.new(identity.id)
				puts "\n#{friend}"
				puts "Klout score: #{user.score.score}\n"
			rescue
				puts "Your friend #{friend} isn't on Klout!"
			end
		end
	end


	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]

			case command
				when 'q' then puts 'GoodBye!'
				when 't' then tweet(parts[1..-1].join(" "))
				when 'd' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt' then everyones_last_tweet
				when 's' then shorten(parts[1..-1].join(" "))
				when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
				# when 'ks' then klout_score
				else
					puts "Sorry, I don't know how to #{command}"
			end
		end
	end
	
end


blogger = MicroBlogger.new
blogger.run
blogger.klout_score