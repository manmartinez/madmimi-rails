require 'madmimi'
module Madmimi
  module Rails
    class Madmimi::Rails::DeliveryMethod
      class InvalidOptions < StandardError; end;

      attr_accessor :settings

      def initialize config = {}
        fail(InvalidOptions, "Missing configuration") if config[:email].nil? || config[:api_key].nil?
        self.settings = config
      end

      def deliver! mail
        options = {
          'promotion_name' => mail.subject,
          'recipients' => mail.to.join(','),
          'from' => mail.from,
          'subject' => mail.subject,
          'remove_unsubscribe' => true
        }
        if mail.parts.any?
          raw = mail.html_part.body.raw_source
        else
          raw = mail.body.raw_source
        end
        mimi = MadMimi.new(settings[:email], settings[:api_key])
        result = mimi.send_html(options, raw)
        ::Rails.logger.info "[INFO] sent email to Madmimi, mailing id is: #{result}"
        result
      end
    end
  end
end
