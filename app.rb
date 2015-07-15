require 'sinatra'
require 'slack-notify'
require 'firebase'

get '/' do
	return "Hello world"
end

post '/cards' do
	card_name = params[:text]
	channel = params[:channel_name]
	team = params[:team_id]
	client = ""
	case team
			when "T07AGCZNZ" 
				client = "T07AGCZNZ/B07HDETK9/cWvG3OEEYv2SXLNepiZUEcTZ"
			when "T02FJ886H"
				client = "T02FJ886H/B07FUFG9J/SdAyVpMjNGUn1XGX7ooPrdeI"
			end
	if card_name == "random" 
		randomCard(channel,client)
	else
		card_name = CapitalizeWords(card_name)
		base_uri = "https://magictgdeckpricer.firebaseio.com/MultiverseTable/#{ card_name }/ids"
		encode = URI::encode(base_uri)
		puts encode 
		firebase = Firebase::Client.new encode
		response = firebase.get("","")
		if response.body
			randomSet = rand(response.body.keys.length)
			mId = response.body[response.body.keys[randomSet]]
			uri = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{mId}&type=card"
			puts uri

			client = SlackNotify::Client.new(
				webhook_url: "https://hooks.slack.com/services/#{client}",
				channel: "##{channel}",
				username: "GathererBot"

			)
			client.notify("#{uri}")
		else
			return "Invalid or Mispelled Card Name"
		end	
	end
end

def randomCard(channel,client)

	randomNumber = rand(14418)
	base_uri = "https://magictgdeckpricer.firebaseio.com/MultiverseTable/"
	firebase = Firebase::Client.new base_uri
		response = firebase.get("","")
		rId = response.body[response.body.keys[randomNumber]]['name']
		base_uri = "https://magictgdeckpricer.firebaseio.com/MultiverseTable/#{rId}/ids"
		puts base_uri
		base_uri = URI::encode(base_uri)
		firebase = Firebase::Client.new base_uri
		response = firebase.get("","")
		random = rand(response.body.keys.length)
		mId = response.body[response.body.keys[random]]
		uri = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{mId}&type=card"
		client = SlackNotify::Client.new(
				webhook_url: "https://hooks.slack.com/services/#{client}",
				channel: "##{channel}",
				username: "GathererBot"

			)
			client.notify("#{uri}")
	
end



def CapitalizeWords(string)
	string = string.split.map(&:capitalize).join(' ')
	string.sub! "Of The","of the"
	puts string
	return string
end
