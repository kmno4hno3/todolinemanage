class LinebotController < ApplicationController
    require 'line/bot'

    protect_from_forgery :except => [:callback]

    def client
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end

    def callback
        # request：リクエストを送ってきたユーザのヘッダー情報や環境変数を取得
        # body：ポストデータを取得
        body = request.body.read

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
            head :bad_request
        end
end
