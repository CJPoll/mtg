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
	base_uri = "https://magictgdeckpricer.firebaseio.com/MultiverseTable/#{ card_name }/ids"

	encode = URI::encode(base_uri)
	puts encode 
	firebase = Firebase::Client.new encode
	response = firebase.get("","")
	randomSet = 1 + rand(response.body.keys.length)
	mId = response.body[response.body.keys[randomSet]]
	uri = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{mId}&type=card"
	puts uri

	client = SlackNotify::Client.new(
		webhook_url: "https://hooks.slack.com/services/#{client}",
		username: "GathererBot",
		channel: "##{channel}"
	)
	client.notify("Channel: #{channel}\n #{uri}")
end
