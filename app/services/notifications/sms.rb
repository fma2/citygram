module Citygram
  module Services
    module Notifications
      class SMS < Base
        FROM_NUMBER = ENV.fetch('TWILIO_FROM_NUMBER')

        def self.client
          @client ||= Twilio::REST::Client.new(
            ENV.fetch('TWILIO_ACCOUNT_SID'),
            ENV.fetch('TWILIO_AUTH_TOKEN')
          )
        end

        def call
          self.class.client.account.messages.create(
            from: FROM_NUMBER,
            to: subscription.contact,
            body: event.title
          )
        rescue Twilio::REST::RequestError => e
          Citygram::App.logger.error(e)
          # TODO: deactivate subscription?
          raise NotificationFailure, e
        end
      end

      add_channel :sms, Citygram::Services::Notifications::SMS
    end
  end
end
