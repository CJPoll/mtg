require 'sinatra'
require 'slack-notify'
require 'firebase'

get '/' do
	return "Hello world"
end

post '/cards' do
	card_name = params[ :text ]
	channel = params[ :channel_name ]

	card_data = get_card_data(card_name)
	set_data = get_set_data( card_name )

	set_uri = 'https://magictgdeckpricer.firebaseio.com/setInfoX/'
	firebase = Firebase::Client.new set_uri
	encodedSet = URI::encode(set)
	setBaseResponse = firebase.get(encodedSet)
	code = setBaseResponse.body['code']


	client = SlackNotify::Client.new(
		webhook_url: 'https://hooks.slack.com/services/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'
	)
	client.notify( "Channel: #{channel}\nSet Data: #{ setData }" )
end

def get_card_data( card_name )
	card_path = "allCards/#{ card_name }/"
	firebase.get( card_path )
end

def get_set_data( card_name )
	set_path = 'setInfoX/'
	firebase.get( set_path, { 
		'orderBy' => 'name',
		'startAt' => card_name,
		endAt => card_name,
		'limitToFirst' => 1 
	})
end

def firebase
	base_uri = "https://magictgdeckpricer.firebaseio.com/"
	Firebase::Client.new base_uri
end
