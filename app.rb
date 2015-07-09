require 'sinatra'
require 'slack-notify'
require 'firebase'

get '/' do
	return "Hello world"
end

post '/cards' do
	card_name = params[:text]

	base_uri = "https://magictgdeckpricer.firebaseio.com/allCards/"
	firebase = Firebase::Client.new base_uri
	card_path = "#{ card_name }.json"
	response = firebase.get(card_path)
	client = SlackNotify::Client.new(
		webhook_url: "https://hooks.slack.com/services/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",
		channel: '#testing-slashes'
	)
	client.notify("#{card_name} successful?: #{response.success?}")
end
