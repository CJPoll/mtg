require 'sinatra'
require 'slack-notify'
require 'firebase'

get '/' do
	return "Hello world"
end

post '/cards' do
	card_name = params[:text]
	channel = params[:channel_name]

	base_uri = "https://magictgdeckpricer.firebaseio.com/MultiverseTable/#{ card_name }/ids"

	encode = URI::encode(base_uri)
	puts encode 
	firebase = Firebase::Client.new encode
	response = firebase.get("","")
	randomSet = 1 + rand(response.body.keys.length)
	mId = response.body[response.body.keys[randomSet]]
	uri = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{mId}&type=card"

	client = SlackNotify::Client.new(
		webhook_url: "https://hooks.slack.com/services/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",

		channel: "##{channel}"
	)
	client.notify("Channel: #{channel}\n#{card_name}: #{uri}")
end
