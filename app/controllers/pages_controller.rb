equire 'rubygems'
require 'sinatra'
require 'tropo-webapi-ruby'

class PagesController < ApplicationController
def home
@title = "Home"
end
def contact
@title = "Contact"
end
def about
@title = "About"
end
def voicepin
 post '/ask.json' do
    tropo = Tropo::Generator.new do
              on :event => 'hangup', :next => '/hangup.json'
              on :event => 'continue', :next => '/answer.json'
              call({ :to => 'tel:+16132241479'}) do
               ask({ :name    => 'pin_number',
                    :bargein => true,
                    :timeout => 30,
                    :require => 'true' }) do
                      say     :value => 'Please enter your pin number'
                      choices :value => '[4 DIGITS]'
                    end
               end
              end
    tropo.response
  end

  # Produces a Ruby hash, if the user gives a response before hanging up:
  #
  # { :result =>
  #   { :actions          => { :attempts       => 1,
  #                            :disposition    => "SUCCESS",
  #                            :interpretation => "12345",
  #                            :confidence     => 100,
  #                            :name           => "account_number",
  #                            :utterance      => "1 2 3 4 5" },
  #     :session_duration => 3,
  #     :error            => nil,
  #     :sequence         => 1,
  #     :session_id       => "5325C262-1DD2-11B2-8F5B-C16F64C1D62E@127.0.0.1",
  #     :state            => "ANSWERED",
  #     :complete         => true } }
  #
  # tropo_event = Tropo::Generator.parse request.env["rack.input"].read
  # All three of these are now valid with Hashie
  # 'Call Answered!' if tropo_event.result.call_state == 'Answered'
  # 'Call Answered!' if tropo_event[:result][:call_state] == 'Answered'
  # 'Call Answered!' if tropo_event['result']['call_state'] == 'Answered'

  post '/answer.json' do
    tropo_event = Tropo::Generator.parse request.env["rack.input"].read
    #p tropo_event
    p 'PIN Verified!' if tropo_event.result.call_state == 'Answered'
  end

  post '/hangup.json' do
    tropo_event = Tropo::Generator.parse request.env["rack.input"].read
    p tropo_event
  end

end
end
