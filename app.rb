require 'sinatra'
require 'slack-notify'
require 'firebase'

get '/' do
	return "Hello world"
end

post '/cards' do
	card_name = params[:text]
	channel = params[:channel_id]

	base_uri = "https://magictgdeckpricer.firebaseio.com/allCards/"
	firebase = Firebase::Client.new base_uri
	card_path = "#{ card_name }"
	response = firebase.get(card_path)
	client = SlackNotify::Client.new(
		webhook_url: "https://hooks.slack.com/services/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",
		channel: "##{channel}"
	)
	client.notify("Channel: #{channel}\n#{card_name}: #{response.body}")
end
