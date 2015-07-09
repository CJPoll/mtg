require 'sinatra'
require 'slack-notify'

post '/cards' do
	card_name = params[:text]

	base_uri = "https://magictgdeckpricer.firebaseio.com/allCards/"
	firebase = Firebase::Client.new base_uri
	response = firebase.get "/allCards/#{ card_name }.json"
	client = SlackNotify::Client.new(
		webhook_url: "https://hooks.slack.com/services/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",
	)
	client.notify(response)

end
